// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

import $ from 'jquery';

$(document).ready(function() {
  $('.ui.dropdown')
    .dropdown();

  $('.ui.green.ribbon.label')
    .popup();

  $('.activator')
    .popup();

  $('.close.icon')
    .on('click', function() {
      $(this)
        .closest('.message')
        .transition('fade')
    });

  $('.ui.form.streams')
    .form({
      fields: {
        name: {
          identifier: 'stream[name]',
          rules: [
            {
              type: 'empty',
							prompt : 'Please enter stream\'s name'
            }
          ]
        }
      }
    })

	$('.ui.form.stages')
		.form({
			fields: {

				shockIdentifier: {
					identifier: 'stage[shock_identifier]',
					rules: [
						{
							type: 'empty',
							prompt : 'Please enter stage\'s identifier'
						}
					]
				},

				title: {
					identifier: 'stage[title]',
					rules: [
						{
							type: 'empty',
							prompt : 'Please enter stage\'s title'
						}
					]
				},

				step: {
					identifier: 'stage[step]',
					rules: [
						{
							type: 'empty',
							prompt : 'please select a step'
						}
					]
				}

			}
		})
});
