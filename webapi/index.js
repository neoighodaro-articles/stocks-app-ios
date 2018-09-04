// import dependencies
const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');
const Pusher = require('pusher');
const PushNotifications = require('@pusher/push-notifications-server');

// initialise express
const app = express();
const pusher = new Pusher(require('./config.js'));
const pushNotifications = new PushNotifications(require('./config.js'));

function generateRandomFloat(min, max) {
  return parseFloat((Math.random() * (max - min) + min).toFixed(2));
}

function getPercentageString(percentage) {
  let operator = percentage < 0 ? '' : '+';
  return `${operator}${percentage}%`;
}

function loadStockDataFor(stock) {
  return {
    name: stock,
    price: generateRandomFloat(0, 1000),
    percentage: getPercentageString(generateRandomFloat(-10, 10))
  };
}

app.get('/stocks', (req, res) => {
  let stocks = [
    loadStockDataFor('AAPL'),
    loadStockDataFor('GOOG'),
    loadStockDataFor('AMZN'),
    loadStockDataFor('MSFT'),
    loadStockDataFor('NFLX'),
    loadStockDataFor('TSLA')
  ];

  stocks.forEach(stock => {
    let name = stock.name;
    let percentage = stock.percentage.substr(1);
    let verb = stock.percentage.charAt(0) === '+' ? 'up' : 'down';
    pushNotifications.publish([stock.name], {
      apns: {
        aps: {
          alert: {
            title: `Stock price change: "${name}"`,
            body: `The stock price of "${name}" has gone ${verb} by ${percentage}.`
          }
        }
      }
    });
  });

  pusher.trigger('stocks', 'update', stocks);

  res.json(stocks);
});

app.listen(5000, () => console.log('Server is running'));
