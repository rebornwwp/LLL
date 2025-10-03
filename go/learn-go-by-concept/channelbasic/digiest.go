package channelbasic

import (
	"crypto/md5"
	"errors"
	"io/fs"
	"io/ioutil"
	"os"
	"path/filepath"
	"sync"
)

// MD5All reads all the files in the file tree rooted at root and returns a map
// from file path to the MD5 sum of the file's contents.  If the directory walk
// fails or any read operation fails, MD5All returns an error.
func MD5All(root string) (map[string][md5.Size]byte, error) {
	m := make(map[string][md5.Size]byte)
	err := filepath.Walk(root, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.Mode().IsRegular() {
			return nil
		}
		data, err := ioutil.ReadFile(path)
		if err != nil {
			return err
		}
		m[path] = md5.Sum(data)
		return nil
	})
	if err != nil {
		return nil, err
	}
	return m, nil
}

type result struct {
	path string
	sum  [md5.Size]byte
	err  error
}

func sumFile(done <-chan struct{}, root string) (chan result, chan error) {
	c := make(chan result)
	errc := make(chan error, 1)

	go func() {
		var wg sync.WaitGroup

		err := filepath.Walk(root, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}
			if !info.Mode().IsRegular() {
				return nil
			}

			wg.Add(1)
			go func() {
				data, err := ioutil.ReadFile(path)
				select {
				case c <- result{path, md5.Sum(data), err}:
				case <-done:
				}
				wg.Done()
			}()
			// Abort the walk if done is closed.
			select {
			case <-done:
				return errors.New("walk canceled")
			default:
				return nil
			}
		})

		go func() {
			wg.Wait()
			close(c)
		}()

		errc <- err
	}()
	return c, errc
}

// 平行读取，但是读取文件到内存的速度过快，可能导致内存使用超过memory的最大限制
func MD5AllParr(root string) (map[string][md5.Size]byte, error) {
	done := make(chan struct{})
	defer close(done)

	result, errs := sumFile(done, root)

	m := make(map[string][md5.Size]byte)

	for x := range result {
		if x.err != nil {
			return nil, x.err
		}
		m[x.path] = x.sum
	}

	if err := <-errs; err != nil {
		return nil, err
	}
	return m, nil
}

// 增加对文件的限制
func walkFiles(done chan struct{}, root string) (<-chan string, <-chan error) {
	paths := make(chan string)
	errc := make(chan error, 1)

	go func() {
		defer close(paths)
		errc <- filepath.Walk(root, func(path string, info fs.FileInfo, err error) error {
			if err != nil {
				return err
			}
			if !info.Mode().IsRegular() {
				return nil
			}

			select {
			case paths <- path:
			case <-done:
				return errors.New("walk files canceled")
			}

			return nil
		})
	}()
	return paths, errc
}

func digester(done <-chan struct{}, paths <-chan string, c chan<- result) {
	for path := range paths {
		data, err := ioutil.ReadFile(path)
		select {
		case c <- result{path: path, sum: md5.Sum(data), err: err}:
		case <-done:
			return
		}
	}
}

func MD5AllWithLimit(root string) (map[string][md5.Size]byte, error) {
	done := make(chan struct{})
	defer close(done)
	paths, errc := walkFiles(done, root)

	c := make(chan result)

	var wg sync.WaitGroup
	const numDigesters = 20
	wg.Add(numDigesters)

	for i := 0; i < numDigesters; i++ {
		go func() {
			digester(done, paths, c)
			wg.Done()
		}()
	}

	go func() {
		wg.Wait()
		close(c)
	}()

	m := make(map[string][md5.Size]byte)

	for r := range c {
		if r.err != nil {
			return nil, r.err
		}

		m[r.path] = r.sum
	}

	if err := <-errc; err != nil {
		return nil, err
	}

	return m, nil
}
