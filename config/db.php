<?php

$host = "sql203.infinityfree.com";
$user = "if0_42252420";
$password = "2230223522";
$database = "if0_42252420_finfish";

$conn = mysqli_connect($host,$user,$password,$database);

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}