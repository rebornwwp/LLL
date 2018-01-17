from collections import OrderedDict
import tablib
from sqlalchemy import create_engine, inspect, text

import os
DATABASE_URL = os.environ.get('DATABASE_URL')


class Record(object):
    def __init__(self, keys, values):
        self._keys = keys
        self._values = values

        assert len(self._keys) == len(self._values)

    def keys(self):
        return self._keys

    def values(self):
        return self._values

    def __repr__(self):
        return '<Record {}>'.format(self.export('json')[1:-1])

    def __getitem__(self, key):
        if isinstance(key, int):
            return self.values()[key]

        if key in self.keys():
            i = self.keys().index(key)
            return self.values()[i]
        raise KeyError("Record not contains {} key".format(key))

    def __getattr__(self, key):
        try:
            self[key]
        except KeyError as e:
            raise AttributeError(e)

    def __dir__(self):
        standard = dir(super(Record, self))
        return sorted(standard + [str(k) for k in self.keys()])

    def get(self, key, default=None):
        try:
            self[key]
        except KeyError:
            return default

    def as_dict(self, sorted=False):
        items = zip(self.keys(), self.values())

        return OrderedDict(items) if sorted == True else dict(items)

    @property
    def dataset(self):
        data = tablib.Dataset()
        data.headers = self.keys()

        row = _reduce_datetimes(self.values())
        data.append(row)
        return data

    def export(self, format, **kwargs):
        return self.dataset.export(format, **kwargs)


class RecordCollection(object):
    def __init__(self, rows):
        self._rows = rows
        self._all_rows = []
        self.pending = True

    def __repr__(sel):
        return '<RecordCollection size={} pending={}'.format(len(self), self.pending)

    def __iter__(self):
        i = 0
        while True:
            if i < len(self):
                yield self[i]
            else:
                try:
                    yield next(self)
                except StopIteration:
                    return
            i += 1

    def next(self):
        return self.__next__()

    def __next__(self):
        try:
            nextrow = next(self)
            self._all_rows.append(nextrow)
            return nextrow
        except StopIteration:
            self.pending = False
            raise StopIteration("RecordCollection contains no more rows")

    def __getitem__(self, key):
        is_int = isinstance(key, int)
        if is_int:
            key = slice(key, key+1)
        
        while len(self) < key.stop or key.stop is None:
            try:
                next(self)
            except StopIteration:
                break
        if is_int:
            return rows[0]



    def __len__(self):
        return len(self._all_rows)

    def export(self, format, **kwargs):
        return self.Dataset.export(format, **kwargs)

    @property
    def Dataset(self):
        data = tablib.Dataset()
        if len(list(self)) == 0:
            return data

        first = data[0]
        data.headers = first.keys()
        for row in self.all():
            row = _reduce_datetimes(row.values())
            data.append(row)

        return data

    def all(self, as_dict=False, as_ordereddict=False):
        rows = list(self)

        if as_dict:
            return [r.as_dict() for r in rows]
        elif as_ordereddict:
            return [r.as_dict(ordered=True) for r in rows]

        return rows

    def as_dict(self, ordered=False):
        return self.all(as_dict=not(ordered), as_ordereddict=ordered)

    def first(self, default=False, as_dict=False, as_ordereddict=False):
        pass


class Database(object):
    def __init__(self, db_url=None, **kwargs):
        self.db_url = db_url or DATABASE_URL

        if not self.db_url:
            raise ValueError("db_url error")

        self._engine = create_engine(self.db_url, **kwargs)
        self.db = self._engine.connect()
        self.open = True

    def close(self):
        self.db.close()
        self.open = False

    def __enter__(self):
        return self

    def __exit__(self, exc, val, traceback):
        self.close()

    def __repr__(self):
        return "<Dataset open={}>".format(self.open)

    def get_table_names(self, internal=False):
        return inspect(self._engine).get_table_names()

    def query(self, query, fetchall=False, **params):
        cursor = self.db.execute(text(query), **params)

        row_gen = (Record(cursor.keys(), row) for row in cursor)

        results = RecordCollection(row_gen)
        if fetchall:
            results.all()
        return results

    def bulk_query(self, query, *multiparams):
        self.db.execute(query, *multiparams)

    def query_file(self, path, fetchall=False, **params):
        if not os.path.exists(path):
            raise IOError("file '{}' not found".format(path))

        if os.path.isdir(path):
            raise IOError("'{}' is a directory".format(path))

        with open(path) as f:
            query = f.read()

        return self.query(query=query, fetchall=fetchall, **params)

    def bulk_query_file(self, path, *multiparams):
        if not os.path.exists(path):
            raise IOError("file '{}' not found".format(path))
        if os.path.isdir(path):
            raise IOError("'{}' is a directory".format(path))

        with open(path) as f:
            query = f.read()

        return self.db.execute(text(query) * multiparams)

    def transaction(self):
        return self.db.begin()


def _reduce_datetimes(l):
    l = list(l)
    for i in range(len(l)):
        if hasattr(l[i], 'iosformat'):
            l[i] = l[i].iosformat()
    return tuple(l)


def main():
    row = Record(['a', 'b', 'c'], [1, 2, 3])
    print(row.keys())
    print(row.values())


if __name__ == '__main__':
    main()
