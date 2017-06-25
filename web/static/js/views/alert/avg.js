import MainView from '../main'
import {Socket} from "phoenix"

var avgChart = null

export default class View extends MainView {
  mount() {
    super.mount()
    this.loadHighcharts()
    this.loadWebSocket()
  }

  unmount() {
    super.unmount()
  }

  loadHighcharts() {
    var Highcharts = require('highcharts/highstock');

    avgChart = Highcharts.chart('avg-container', {
      chart: {
        type: 'spline'
      },
      series: [{
        name: 'Temperature',
        data: []
      }]
    })
  }

  loadWebSocket() {
    let socket = new Socket("/socket", {params: {token: window.userToken}})
    socket.connect()

    var topic = "alerts:lobby"
    let channel = socket.channel(topic, {})

    window.setInterval(function() {
      $.ajax({
        url: '/flush_avg',
        success: function(payload) {}
      })
    }, 5000)

    channel.on('new_avg', payload => {
      var newValue = payload["value"][0]
      avgChart.series[0].addPoint(newValue, false)
      avgChart.redraw()
    })

    channel.join()
      .receive("ok", resp => { console.log("Joined successfully at alerts:lobby", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })
  }
}
