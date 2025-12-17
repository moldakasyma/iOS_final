# 🐾 PetCast
**PetCast** is an iOS application that displays current weather information for a selected city and visualizes it using a virtual pet.
The pet’s mood and appearance change depending on weather conditions, making weather forecasting more engaging and intuitive.
---
# Project Concept
Instead of showing only numerical weather data, the application uses a virtual animal character to represent different weather conditions:
☀️ Sunny weather — the pet looks happy
🌧 Rainy weather — the pet appears sad
❄️ Snowy weather — the pet remains calm
This approach enhances user experience by combining weather data with emotional visual feedback.
---
# Features
🔍 City search by name
🌍 Real-time weather information:
temperature
“feels like” temperature
weather description
🐼 Animated pet that reacts to weather changes
🌦 Weather animations:
rain
snow
sun
clouds
⭐ Add cities to favorites
📡 No-internet connection handling
🧼 Clean and adaptive UI using Auto Layout and Stack Views
---
# Project Structure
ViewControllers — application screens
Services — network requests and API handling
Models — data models for weather and locations
Views — custom UI elements and animations
This separation improves readability, maintainability, and scalability.

The application uses the OpenWeatherMap API to retrieve weather data.
For security reasons, the API key is not stored in the repository.
