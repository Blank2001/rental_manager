import { Controller } from '@hotwired/stimulus';
import { setOptions, importLibrary } from "@googlemaps/js-api-loader";

export default class extends Controller {
  static values = {
    keys: String
  }

  async connect() {
    // 1. Configure the options globally
    setOptions({
      apiKey: this.keysValue,
      version: "beta",
    });

    try {
      // 2. Import separate functional libraries 
      // Note: Geocoder lives in 'geocoding' (or legacy 'core'), NOT 'maps'
      const { Map, InfoWindow } = await importLibrary("maps");
      const { Geocoder } = await importLibrary("geocoding");
      const { AdvancedMarkerElement } = await importLibrary("marker");

      // 3. Initialize your map elements
      this.map = new Map(document.getElementById("map"), {
        zoom: 16,
        mapId: '8c893b08dcdd4346',
      });

      this.infoWindow = new InfoWindow();
      this.geocoder = new Geocoder();

      this.draggableMarker = new AdvancedMarkerElement({
        map: this.map,
        gmpDraggable: true,
        title: "Current Location",
      });

      // 4. Bind event listeners
      this.draggableMarker.addListener("dragend", () => {
        this.showPlaceDetails();
        
        const position = this.draggableMarker.position;
        const latitudeInput = document.getElementById("latitude");
        const longitudeInput = document.getElementById("longitude");
        
        if (latitudeInput && longitudeInput && position) {
          latitudeInput.value = typeof position.lat === "function" ? position.lat() : position.lat;
          latitudeInput.value = typeof position.lng === "function" ? position.lng() : position.lng;
        }
      });

      // 5. Initialize user geolocation
      this.getCurrentLocation();

    } catch (error) {
      console.error("Failed to load Google Maps setup:", error);
    }
  }

  async showPlaceDetails() {
    const position = this.draggableMarker.position;
    if (!position) return;
    
    try {
      const response = await this.geocoder.geocode({ location: position });
      if (response.results && response.results[0]) {
        const formattedAddress = response.results[0].formatted_address;
        
        // Update your UI or input targets here
        this.infoWindow.setContent(formattedAddress);
        this.infoWindow.open(this.map, this.draggableMarker);
      }
    } catch (error) {
      console.error("Geocoding failed:", error);
    }
  }

  getCurrentLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const userPos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          };

          // Center the map and place the interactive marker
          this.map.setCenter(userPos);
          this.draggableMarker.position = userPos;
          
          // Populate the forms on first load
          const latitudeInput = document.getElementById("latitude");
          const longitudeInput = document.getElementById("longitude");
          if (latitudeInput && longitudeInput) {
            latitudeInput.value = userPos.lat;
            longitudeInput.value = userPos.lng;
          }
          
          this.showPlaceDetails();
        },
        (error) => {
          console.warn("Geolocation access denied or unavailable:", error);
        }
      );
    } else {
      console.error("Your browser does not support geolocation.");
    }
  }
}
