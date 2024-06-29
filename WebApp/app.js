document.addEventListener("DOMContentLoaded", function () {
    const countryNames = getCountryNames();

    const cityInput = document.querySelector(".cityInput");
    const suggestionsList = document.querySelector(".suggestions");
    const locationButton = document.querySelector(".locationButton");
    const weatherDegrees = document.querySelector(".weather_degrees");
    const dailyForecasts = document.querySelectorAll(".day_temp");

    let isFahrenheit = false;

    
    function celsiusToFahrenheit(celsius) {
        return (celsius * 9 / 5) + 32;
    }

    
    function updateTemperatures() {
        const temperatureElements = [
            document.querySelector('.weather_degrees'), 
            ...document.querySelectorAll('.day_temp'),
            document.querySelector('.feels_like_detail')
        ];

        temperatureElements.forEach(element => {
            const originalTemp = element.dataset.originalTemp; 
            if (!originalTemp.includes('/')) {
                
                let currentTemp = parseFloat(originalTemp);
                if (isFahrenheit) {
                    currentTemp = celsiusToFahrenheit(currentTemp);
                    element.textContent = element.classList.contains('feels_like_detail') 
                        ? `Feels Like: ${Math.round(currentTemp)}°F` 
                        : `${Math.round(currentTemp)}°F`;
                } else {
                    element.textContent = element.classList.contains('feels_like_detail') 
                        ? `Feels Like: ${Math.round(currentTemp)}°C` 
                        : `${Math.round(currentTemp)}°C`;
                }
            } else {
                
                let [maxTemp, minTemp] = originalTemp.split('/').map(temp => parseFloat(temp));
                if (isFahrenheit) {
                    maxTemp = celsiusToFahrenheit(maxTemp);
                    minTemp = celsiusToFahrenheit(minTemp);
                    element.textContent = `${Math.round(maxTemp)}°F/${Math.round(minTemp)}°F`;
                } else {
                    element.textContent = `${Math.round(maxTemp)}°C/${Math.round(minTemp)}°C`;
                }
            }
        });

        
        if (hourlyTemperatureChart) {
            hourlyTemperatureChart.data.datasets[0].data = hourlyTemperatureChart.data.datasets[0].data.map(temp => {
                return isFahrenheit ? celsiusToFahrenheit(temp) : (temp - 32) * 5 / 9;
            });
            hourlyTemperatureChart.options.scales.y.title.text = `Temperature (${isFahrenheit ? '°F' : '°C'})`;
            hourlyTemperatureChart.update();
        }
    }

    
    const toggleButton = document.getElementById("toggleFahrenheit");
    toggleButton.addEventListener('click', function () {
        isFahrenheit = !isFahrenheit; 
        updateTemperatures(); 
        toggleButton.classList.toggle('active'); 
        
        if (isFahrenheit) {
            toggleButton.textContent = "Change to Celsius";
        } else {
            toggleButton.textContent = "Change to Fahrenheit";
        }
    });


    async function getWeatherForCurrentLocation() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(async function (position) {
                const { latitude, longitude } = position.coords;
                try {
                    const weatherData = await getWeatherDataByCoordinates(latitude, longitude);
                    displayWeatherInfo(weatherData);
    
                    const cityID = weatherData.id; 
                    const dailyForecast = await getDailyForecastByCityID(cityID);
                    if (dailyForecast) {
                        displayDailyForecast(dailyForecast);
                    } else {
                        displayError("Could not fetch daily forecast. Please try again later.");
                    }
                } catch (error) {
                    console.error(error);
                    displayError("Could not fetch weather data. Please try again later.");
                }
            }, function (error) {
                console.error(error);
                displayError("Unable to retrieve your location. Please check your location settings and try again.");
            });
        } else {
            displayError("Geolocation is not supported by this browser.");
        }
    }
    
    
    

    async function fetchCities(query) {
        try {
            const response = await fetch('/axd/city.list.json');
            const cities = await response.json();
            const filteredCities = cities.filter(city => 
                city.name.toLowerCase().includes(query.toLowerCase()) || 
                (city.state && city.state.toLowerCase().includes(query.toLowerCase()))
            );

            filteredCities.sort((a, b) => {
                const nameA = a.name.toLowerCase();
                const nameB = b.name.toLowerCase();
                if (nameA.startsWith(query.toLowerCase()) && !nameB.startsWith(query.toLowerCase())) {
                    return -1;
                }
                if (!nameA.startsWith(query.toLowerCase()) && nameB.startsWith(query.toLowerCase())) {
                    return 1;
                }
                return nameA.localeCompare(nameB);
            });

            const uniqueCities = [];
            const cityNames = new Set();
            for (const city of filteredCities) {
                const cityNameWithLocation = `${city.name}, ${city.state ? city.state + ', ' : ''}${countryNames[city.country]}`;
                if (!cityNames.has(cityNameWithLocation)) {
                    uniqueCities.push(city);
                    cityNames.add(cityNameWithLocation);
                }
            }

            return uniqueCities.slice(0, 10);
        } catch (error) {
            console.error("Error fetching cities:", error);
            return [];
        }
    }

    function renderSuggestions(citySuggestions) {
        const fragment = document.createDocumentFragment();
        suggestionsList.innerHTML = '';

        citySuggestions.forEach(suggestion => {
            const listItem = document.createElement('li');
            const countryName = countryNames[suggestion.country] || suggestion.country;
            listItem.textContent = `${suggestion.name}, ${suggestion.state ? suggestion.state + ', ' : ''}${countryName}`;
            listItem.addEventListener('click', () => {
                cityInput.value = listItem.textContent;
                suggestionsList.innerHTML = '';
                fetchWeatherByCityID(suggestion.id);
            });
            fragment.appendChild(listItem);
        });

        suggestionsList.appendChild(fragment);
    }

    async function fetchWeatherByCityID(cityID) {
        try {
            const weatherData = await getWeatherDataByCityID(cityID);
            displayWeatherInfo(weatherData);

            
            const dailyForecast = await getDailyForecastByCityID(cityID);
            if (dailyForecast) {
                displayDailyForecast(dailyForecast);
            } else {
                displayError("Could not fetch daily forecast. Please try again later.");
            }
        } catch (error) {
            console.error(error);
            displayError("Could not fetch weather data. Please try again later.");
        }
    }

    function initializeAutocomplete() {
        cityInput.addEventListener('input', debounce(async function () {
            const query = cityInput.value.trim();
            if (query.length >= 3) {
                const citySuggestions = await fetchCities(query);
                renderSuggestions(citySuggestions);
            } else {
                suggestionsList.innerHTML = '';
            }
        }, 300));

        
        cityInput.addEventListener('focus', function () {
            cityInput.select();
        });
    }

    locationButton.addEventListener('click', function () {
        cityInput.value = '';
        suggestionsList.innerHTML = '';
        getWeatherForCurrentLocation();
    });

    initializeAutocomplete();
    getWeatherForCurrentLocation();
    initEventListeners();
});
