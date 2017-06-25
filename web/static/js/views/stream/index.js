import MainView from '../main'

export default class View extends MainView {
  mount() {
    super.mount()
    console.log('StreamsIndex mounted...')
  }

  unmount() {
    super.unmount()
    console.log('StreamsIndex unmounted...')
  }
}
