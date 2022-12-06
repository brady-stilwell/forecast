document.addEventListener('DOMContentLoaded', function () {
  const forecastForm = document.getElementById('forecast-form');

  forecastForm.addEventListener('submit', handleForecastFormSubmit);
}, false);

let handleForecastFormSubmit = (e) => {
  e.preventDefault();
  e.stopPropagation();

  clearStaleResults()

  let formData = new FormData(e.target)
  let zipCode = formData.get('zip')
  let formAction = e.target.action
  let params = new URLSearchParams({ zip: zipCode })

  // TODO: Add validations!!

  return fetch(`${formAction}?${params}`)
    .then(data => data.json())
    .then(parsedResponse => appendResult(parsedResponse))
    .catch(e => console.error(e))
}

let appendResult = ({ success, data, cached }) => {
  let container = document.querySelector("#result-container")
  let child = document.createElement('p');
  child.innerHTML = success ? `The current temperature is ${data.main.temp}℉ in ${data.name}` : data.message
  container.appendChild(child)

  success && appendHighLow(container, data.main.temp_max, data.main.temp_min)
  appendCacheIndicator(container, cached)
}

let appendHighLow = (container, high, low) => {
  let cacheIndicator = document.createElement('p');
  cacheIndicator.innerHTML = `The current high is ${high}℉ and the current low is ${low}℉`
  container.appendChild(cacheIndicator)
}

let appendCacheIndicator = (container, cached) => {
  let cacheIndicator = document.createElement('p');
  cacheIndicator.innerHTML = cached ? 'The response was cached.' : 'The response was not cached.'
  container.appendChild(cacheIndicator)
}

let clearStaleResults = () => {
  let container = document.querySelector("#result-container")
  while (container.firstChild) {
    container.removeChild(container.lastChild);
  }
}
