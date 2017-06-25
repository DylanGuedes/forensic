import $ from 'jquery';
import {Socket} from "phoenix"

$(document).ready(function() {

  var Highcharts = require('highcharts/highstock');

  $(function() {
    var chart = Highcharts.chart('avg-container', {
      chart: {
        type: 'spline'
      },
      title: {
        text: 'Temperatura corporal do paciente.'
      },
      yAxis: {
        title: {
          text: 'Temperature (°C)'
        }
      },
      tooltip: {
        valueSuffix: '°C'
      },

      series: [{
        name: 'Temperature',
        data: [8, 2]
      }]
    })

    $('.nice').on('click', function() {
      console.log("series => ", chart.series[0])
      chart.series[0].update({data: [8, 2, 7, 4]})
    })
  })


  let socket = new Socket("/socket", {params: {token: window.userToken}})

  socket.connect()

  var topic = "alerts:lobby"
  let channel = socket.channel(topic, {})

  window.setInterval(function() {
    $.ajax({
      url: '/flush_avg',
      success: function(payload) {
        console.log('yeah')
        console.log(payload)
      }
    })
  }, 5000)

  channel.on('new_avg', payload => {
    console.log(payload)
    var oldData = chart.series[0].data;
  })

  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })
});

export default socket
