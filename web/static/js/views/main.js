import $ from 'jquery'

export default class MainView {
  mount() {
    this.loadSemanticPlugins()
    this.loadSemanticForms()

    console.log('MainView mounted')
  }

  unmount() {
    console.log('MainView unmounted')
  }

  loadSemanticPlugins() {
    console.log('loading Semantic-UI plugins...')
    $('.ui.dropdown').dropdown();
    $('.ui.green.ribbon.label').popup();
    $('.activator').popup();

    $('.close.icon').on('click', function() {
      $(this)
        .closest('.message')
        .transition('fade')
    });
  }

  loadSemanticForms() {
    console.log('loading Semantic-UI forms...')
    $('.ui.form.streams').form({
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

    $('.ui.form.stages').form({
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
  }
}
