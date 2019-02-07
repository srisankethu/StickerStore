const express = require('express');
const path = require('path');
var bodyParser = require('body-parser');
var request = require('request');
var fs = require('fs');

var relayer = require('0x.js');

const app = express();

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

app.use(bodyParser.json()); // support json encoded bodies
app.use(bodyParser.urlencoded({ extended: true })); // support encoded bodies
app.use(express.static('images'));

app.get('/', function(req, res){
	res.render('index');
});

app.get('/login', function(req, res){
	res.render('login');
});

app.get('/register', function(req, res){
	res.render('register');
});

app.get('/marketplace', function(req, res){
	let rawdata = fs.readFileSync('stickers.json');
	let stickers = JSON.parse(rawdata);
	res.render('marketplace', {stickers: stickers});
})

app.get('/sticker/:id', function(req, res){
	let rawdata = fs.readFileSync('stickers.json');
	let stickers = JSON.parse(rawdata);
	for(var i = 0; i < stickers.length; i++){
		if(i+1 == req.params.id){
			break;
		}
	}
	var sticker = stickers[i]
	if(sticker == undefined){
		sticker = {
			'name': '',
			'addr': '',
			'image': '',
			'cost': ''
		}
	}
	res.render('sticker', {sticker: sticker})
})

app.listen(3000, function(){
	console.log('Server started on port 3000');
});
