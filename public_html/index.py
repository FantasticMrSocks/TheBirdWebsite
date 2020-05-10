#!/usr/bin/env python3
import cgitb
cgitb.enable()
#HTTP header
print("Content-type: text/html")
print("")

import cgi
import json
import mysql.connector

import script.db

with open("../../bird_db") as f:
	data = json.load(f)

print("<!DOCTYPE html>")
print(f"""
<html>
	<head>
		<title>The Bird Website</title>
	</head>
	<body style="background-image:url('potoo.jpg');background-position: center bottom;background-attachment:fixed;background-repeat:no-repeat;background-size:cover;">
	{data["db_user"]}
	</body>
</html>
""")
