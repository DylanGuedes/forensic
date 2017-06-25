import MainView    from './main';
import StreamIndexView from './stream/index';
import AlertAvgView from './alert/avg';

// Collection of specific view modules
const views = {
  StreamIndexView,
  AlertAvgView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
