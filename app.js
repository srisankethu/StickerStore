const express = require('express');
const path = require('path');
var bodyParser = require('body-parser');
var request = require('request');
var fs = require('fs');
var engines = require('consolidate');

const app = express();

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

app.use(bodyParser.json()); // support json encoded bodies
app.use(bodyParser.urlencoded({ extended: true })); // support encoded bodies

app.get('/', function(req, res){
	res.render('index');
});

app.listen(3000, function(){
	console.log('Server started on port 3000');
});
