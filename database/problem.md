# solved_problem

## SQLite3 database or disk is full / the database disk image is malformed
https://stackoverflow.com/questions/5274202/sqlite3-database-or-disk-is-full-the-database-disk-image-is-malformed

``` sql
# losts of ram
sqlite> pragma temp_store = 2;

# a few ram
sqlite> pragma temp_store = 1;
sqlite> pragma temp_store_directory = '/directory/with/lots/of/space';
```

## Access to postgresql

```
postgres psql -h 192.168.99.100 -p 5432 -U postgres --password
```

