oracle-orm
==========

Because the other options are worse.

There's only one other ORM for Node.js that supports Oracle. It says a lot about the cultures of both Node and Oracle.

The other ORM has over a year of open issues on Github, it sometimes generates invalid Oracle SQL statements and does absurd things like creating a table `PEOPLE` for a model named `PERSON` (and `PEOPLES` for `PEOPLE`, ha). I don't like ORMs, I'm forced to use one for a project. I don't want my tools to do unexpected things in the database and that other ORM is full of surprises.

This ORM only supports the features I need. It doesn't support connection pooling, error recovery and all sorts of basic things you'd expect from an ORM. If you want those features added, open an issue or send a pull request.

It's not even SQL injection-safe, for the most part.


# Install

Don't install from npm yet!

First, make sure libaio is installed: `sudo apt-get install libaio1` or `sudo yum install libaio`

Then, go to the [Oracle driver page](http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html) and click on Linux x86-64.

Download `instantclient-basic-linux.x64-12.1.***.zip` and `instantclient-sdk-linux.x64-12.1.***.zip`.

Unzip both into `YOUR_PROJECT/instantclient_12_1`. It won't work if the driver can't be found.

Finally, `npm install oracle-orm` in your project's directory. The install scripts take care of everything.


#### Run the tests

Put the database credentials in `node_modules/oracle-orm/testDB.json` and run `npm test oracle-orm`.


# Usage

```javascript
var ORM = require("oracle-orm");
var oracleConnectData = {
	driver: "oracle"
	hostname: "hostname or IP"
	port: 1521
	database: "database name (SID)"
	user: "username"
	password: "password123"
};
var debug = true;

new ORM(oracleConnectData, debug, function(err, orm){
	orm.getModels(function(err, models){
		// do stuff with the models
	});
});
```

Due to the very callback-heavy nature of SQL, it's recommended to use a tool to deal with that. Promises, Generators, Streamline, Q, Async, etc. are all good options.


# Documentation

Oracle-ORM works by building one Model object per table in the database. Operations on that Model affect the whole table. Operations GET and ALL on a Model return new copies of Units. A Unit maps to a database row. There can be more than one Unit per row. Operations on a Unit only affect that row.

## ORM

#### Getting the Models
```javascript
orm.getModels(function(err, models){
	//do something with the models
});
```

#### Running arbitrary SQL
```javascript
orm.execute(sql, paramsArray, function(err, results){ ... });
```

# Model

In these examples, USER is a Model.

The USER.columns object contains information about the field types.

#### add
```javascript
USER.add({"USER_ID":5, "NAME":"JOE SMITH"}, function(err, results){ ... });
```

#### get
```javascript
// USER_ID between 5 and 20
USER.get({"USER_ID":">5", "USER_ID":"<20"}, [], function(err, results){ ... });

// All users, ordered by USER_ID ascending and NAME descending
USER.get({}, ["USER_ID ASC", "NAME DESC"], function(err, results){ ... });
```

#### all
```javascript
// Shortcut for .get({}, [], cb);
// all() returns Units in a non-deterministic order
USER.all(function(err, results){ ... });
```

#### update
```javascript
// Apply change to the whole table
// Change all "JOE SMITH" with USER_ID greater than 10 to "BOB SMITH"
USER.update({"NAME":"BOB SMITH"}, {"NAME":"='JOE SMITH'", "USER_ID":">10"}, function(err, results){ ... });
```

#### del
```javascript
// Delete everything with a USER_ID smaller than 5
USER.del({"USER_ID":"<5"}, function(err, results){ ... });
```

#### count
```javascript
USER.count(function(err, results){ ... });
```

#### empty
```javascript
USER.empty(function(err, results){ ... });
```


# Unit

#### data
user.data contains the fields and values of a Unit.

#### isDirty
Returns true if the object was modified

#### save
Writes the dirty (modified) fields to the database.

#### sync
Refreshes all fields with fresh values from the database.

#### reset
Brings all fields back to the state they were in when the Unit was created or after the last sync if sync was called at some point.

### Examples

In these examples, user55 is a Unit. Suppose they are executed sequentially.

```javascript
user55.isDirty(); // false
user55.data.NAME = "WILLIAM CAMPBELL";
user55.isDirty(); // true
user55.save(function(err, results){ ... });
user55.isDirty(); // false
console.log(user55.data.NAME); // "WILLIAM CAMPBELL"

user55.data.NAME = "JAMES SMITH";
user55.isDirty(); // true
console.log(user55.data.NAME); // "JAMES SMITH"
user55.sync(function(err, results){ ... });
console.log(user55.data.NAME); // "WILLIAM CAMPBELL"
user55.isDirty(); // false

user55.data.NAME = "JAMES SMITH";
user55.isDirty(); // true
console.log(user55.data.NAME); // "JAMES SMITH"
user55.reset(function(err, results){ ... });
console.log(user55.data.NAME); // "WILLIAM CAMPBELL"
user55.isDirty(); // false


user55.del(function(err, results){ ... }); // Deleted from the database
user55.del(function(err, results){ ... }); // Uncaught Exception: 'Unit USER was deleted and doesn't exist anymore'
```
