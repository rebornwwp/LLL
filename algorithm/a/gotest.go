package main

import (
	"bytes"
	"fmt"
	"io"
	"os"
	"reflect"
	"strconv"
	"time"
)

type Movie struct {
	Title, Subtitle string
	Year            int
	Color           bool
	Actor           map[string]string
	Oscars          []string
	Sequel          *string
}

func main() {
	fmt.Println(Sprint(true))
	t := reflect.TypeOf(3)
	fmt.Println(t.String())
	fmt.Println(t.String() == "int")
	var w io.Writer = os.Stdout
	fmt.Println(reflect.TypeOf(w))
	v := reflect.ValueOf(3)
	fmt.Println(v)
	fmt.Println(v.String())
	t = v.Type()
	fmt.Println(t.String())
	v = reflect.ValueOf(3)
	fmt.Printf("v type is %T\n", v)
	x := v.Interface()
	fmt.Println("x is ", x)
	fmt.Printf("x type is %T\n", x)
	// i := x.(int)
	fmt.Println(x == 3)
	fmt.Println(x)
	var xx int64 = 1
	var d time.Duration = 1 * time.Nanosecond
	fmt.Println(Any(xx))                 // "1"
	fmt.Println(Any(d))                  // "1"
	fmt.Println(Any([]int64{xx}))        // "[]int64 0x8202b87b0"
	fmt.Println(Any([]time.Duration{d})) // "[]time.Duration 0x8202b87e0"
	var i interface{} = 3
	fmt.Printf("%T\n", i)
	Display("i", i)
	Display("&i", &i)

	strangelove := Movie{
		Title:    "Dr. Strangelove",
		Subtitle: "How I Learned to Stop Worrying and Love the Bomb",
		Year:     1964,
		Color:    false,
		Actor: map[string]string{
			"Dr. Strangelove":            "Peter Sellers",
			"Grp. Capt. Lionel Mandrake": "Peter Sellers",
			"Pres. Merkin Muffley":       "Peter Sellers",
			"Gen. Buck Turgidson":        "George C. Scott",
			"Brig. Gen. Jack D. Ripper":  "Sterling Hayden",
			`Maj. T.J. "King" Kong`:      "Slim Pickens",
		},

		Oscars: []string{
			"Best Actor (Nomin.)",
			"Best Adapted Screenplay (Nomin.)",
			"Best Director (Nomin.)",
			"Best Picture (Nomin.)",
		},
	}

	ok, _ := Marshal(strangelove)
	fmt.Println(string(ok))
	fmt.Println(Marshal(strangelove))
	z := 2
	zz := reflect.ValueOf(&z).Elem()   // d refers to the variable x
	px := zz.Addr().Interface().(*int) // px := &x
	*px = 3                           // x = 3
	fmt.Println(z)
	iii := 2
	*(&iii) = 3
	fmt.Println(iii)
}

func Sprint(x interface{}) string {
	type stringer interface {
		String() string
	}
	switch x := x.(type) {
	case stringer:
		return x.String()
	case string:
		return x
	case int:
		return strconv.Itoa(x)
	// ...similar cases for int16, uint32, and so on...
	case bool:
		if x {
			return "trueAAAA"
		}
		return "false"
	default:
		// array, chan, func, map, pointer, slice, struct
		return "???"
	}
}

func Any(value interface{}) string {
	return formatAtom(reflect.ValueOf(value))
}

func formatAtom(v reflect.Value) string {
	switch v.Kind() {
	case reflect.Invalid:
		return "invalid"
	case reflect.Int, reflect.Int8, reflect.Int16,
		reflect.Int32, reflect.Int64:
		return strconv.FormatInt(v.Int(), 10)
	case reflect.Uint, reflect.Uint8, reflect.Uint16,
		reflect.Uint32, reflect.Uint64, reflect.Uintptr:
		return strconv.FormatUint(v.Uint(), 10)
	case reflect.Bool:
		return strconv.FormatBool(v.Bool())
	case reflect.String:
		return strconv.Quote(v.String())
	case reflect.Chan, reflect.Func, reflect.Ptr, reflect.Slice, reflect.Map:
		return v.Type().String() + " 0x" +
			strconv.FormatUint(uint64(v.Pointer()), 16)
	default: // reflect.Array, reflect.Struct, reflect.Interface
		return v.Type().String() + " value"
	}
}

func Display(name string, x interface{}) {
	fmt.Printf("=========== Display %s (%T): ============\n", name, x)
	display(name, reflect.ValueOf(x))
}

func display(path string, v reflect.Value) {
	switch v.Kind() {
	case reflect.Invalid:
		fmt.Printf("%s = invalid\n", path)
	case reflect.Slice, reflect.Array:
		for i := 0; i < v.Len(); i++ {
			display(fmt.Sprintf("%s[%d]", path, i), v.Index(i))
		}
	case reflect.Struct:
		for i := 0; i < v.NumField(); i++ {
			fieldPath := fmt.Sprintf("%s.%s", path, v.Type().Field(i).Name)
			display(fieldPath, v.Field(i))
		}
	case reflect.Map:
		for _, key := range v.MapKeys() {
			display(fmt.Sprintf("%s[%s]", path, formatAtom(key)), v.MapIndex(key))
		}
	case reflect.Ptr:
		if v.IsNil() {
			fmt.Printf("%s = nil\n", path)
		} else {
			display(fmt.Sprintf("(*%s)", path), v.Elem())
		}
	case reflect.Interface:
		if v.IsNil() {
			fmt.Printf("%s = nil\n", path)
		} else {
			fmt.Printf("%s.type = %s\n", path, v.Elem().Type())
			display(path+".value", v.Elem())
		}
	default:
		fmt.Printf("%s = %s\n", path, formatAtom(v))
	}
}

func encode(buf *bytes.Buffer, v reflect.Value) error {
	switch v.Kind() {
	case reflect.Invalid:
		buf.WriteString("nil")

	case reflect.Int, reflect.Int8, reflect.Int16,
		reflect.Int32, reflect.Int64:
		fmt.Fprintf(buf, "%d", v.Int())

	case reflect.Uint, reflect.Uint8, reflect.Uint16,
		reflect.Uint32, reflect.Uint64, reflect.Uintptr:
		fmt.Fprintf(buf, "%d", v.Uint())

	case reflect.String:
		fmt.Fprintf(buf, "%q", v.String())

	case reflect.Ptr:
		return encode(buf, v.Elem())

	case reflect.Array, reflect.Slice: // (value ...)
		buf.WriteByte('(')
		for i := 0; i < v.Len(); i++ {
			if i > 0 {
				buf.WriteByte(' ')
			}
			if err := encode(buf, v.Index(i)); err != nil {
				return err
			}
		}
		buf.WriteByte(')')

	case reflect.Struct: // ((name value) ...)
		buf.WriteByte('(')
		for i := 0; i < v.NumField(); i++ {
			if i > 0 {
				buf.WriteByte(' ')
			}
			fmt.Fprintf(buf, "(%s ", v.Type().Field(i).Name)
			if err := encode(buf, v.Field(i)); err != nil {
				return err
			}
			buf.WriteByte(')')
		}
		buf.WriteByte(')')

	case reflect.Map: // ((key value) ...)
		buf.WriteByte('(')
		for i, key := range v.MapKeys() {
			if i > 0 {
				buf.WriteByte(' ')
			}
			buf.WriteByte('(')
			if err := encode(buf, key); err != nil {
				return err
			}
			buf.WriteByte(' ')
			if err := encode(buf, v.MapIndex(key)); err != nil {
				return err
			}
			buf.WriteByte(')')
		}
		buf.WriteByte(')')

	default: // float, complex, bool, chan, func, interface
		return fmt.Errorf("unsupported type: %s", v.Type())
	}
	return nil
}

// Marshal encodes a Go value in S-expression form.
func Marshal(v interface{}) ([]byte, error) {
	var buf bytes.Buffer
	if err := encode(&buf, reflect.ValueOf(v)); err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}
