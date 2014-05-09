oracle-orm
==========

Because the other options are worse.

There's only one other ORM for Node.js that supports Oracle. It says a lot about both Node and Oracle.

That other ORM is called Persist. There's over a year of open issues on Github, it generates invalid Oracle SQL statements and does absurd things like creating a table `PEOPLE` for a model named `PERSON`. I don't like ORMs, I'm forced to use one for a project. I don't want my tools to do unexpected things in the database and Persist is full of surprises.

This ORM only supports the features I need. It doesn't support connection pooling, error recovery and all sorts of basic things you'd expect from an ORM. If you want those features added, open an issue or send a pull request.

It's not even SQL injection-safe.
