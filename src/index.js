import './main.css';
import dinLight from "../public/fonts/DIN Light.woff"
import dinRegular from "../public/fonts/DIN Regular.woff"
import dinBold from "../public/fonts/DIN Bold.woff"
import regloBold from "../public/fonts/Reglo-Bold.otf"
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';

const app = Elm.Main.init({
  node: document.getElementById('root'),
  flags: {
    fonts: {
      dinLight,
      dinRegular,
      dinBold,
      regloBold,
    },
  },
});


app.ports.scrollCarousel.subscribe(([carouselId, distance]) => {
  const carouselElement = document.getElementById(carouselId)
  carouselElement.scroll({
    left: carouselElement.scrollLeft + distance,
    behavior: 'smooth'
  })
})


app.ports.requestScrollButtonsVisibility.subscribe((carouselIds) => {
  const buttonVisibilities = Object.fromEntries(carouselIds.map((carouselId) => {
    const carouselElement = document.getElementById(carouselId)
    const minScroll = 0
    const maxScroll = carouselElement.scrollWidth - carouselElement.clientWidth

    return [
      carouselId,
      {
        left: carouselElement.scrollLeft > minScroll,
        right: carouselElement.scrollLeft < maxScroll,
      },
    ];
  }));

  app.ports.updateScrollButtonsVisibility.send(buttonVisibilities);
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
