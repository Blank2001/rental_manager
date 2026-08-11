import { Controller } from '@hotwired/stimulus';
import { setOptions, importLibrary } from "@googlemaps/js-api-loader";

export default class extends Controller {
  static values = {
    keys: String
  }

  async connect() {
    setOptions({
      apiKey: this.keysValue,
      version: "beta",
    });

    try {
      const { Map, InfoWindow } = await importLibrary("maps");
      const { Geocoder } = await importLibrary("geocoding");
      const { AdvancedMarkerElement } = await importLibrary("marker");

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

      this.draggableMarker.addListener("dragend", () => {
        this.updateCoordinatesUI();
        this.showPlaceDetails();
      });

      this.getCurrentLocation();

    } catch (error) {
      console.error("Failed to load Google Maps setup:", error);
    }
  }

  updateCoordinatesUI() {
    const position = this.draggableMarker.position;
    const latitudeInput = document.getElementById("latitude");
    const longitudeInput = document.getElementById("longitude");
    
    if (latitudeInput && longitudeInput && position) {
      latitudeInput.value = typeof position.lat === "function" ? position.lat() : position.lat;
      longitudeInput.value = typeof position.lng === "function" ? position.lng() : position.lng;
    }
  }

  async showPlaceDetails() {
    const position = this.draggableMarker.position;
    if (!position) return;
    
    try {
      const response = await this.geocoder.geocode({ location: position });
      if (response.results && response.results[0]) {
        const place = response.results[0];

        this.infoWindow.setContent(place.formatted_address);
        this.infoWindow.open(this.map, this.draggableMarker);

        this.populateAddressFields(place.address_components);
      }
    } catch (error) {
      console.error("Geocoding failed:", error);
    }
  }

  populateAddressFields(components) {
    const cityInput = document.getElementById("city");
    const countryInput = document.getElementById("country");

    let city = "";
    let country = "";

    components.forEach(component => {
      const types = component.types;

      if (types.includes("locality")) {
        city = component.long_name;
      } else if (!city && types.includes("postal_town")) {
        city = component.long_name;
      } else if (!city && types.includes("administrative_area_level_2")) {
        city = component.long_name;
      }

      if (types.includes("country")) {
        country = component.long_name;
      }
    });
    if (cityInput) cityInput.value = city;
    if (countryInput) countryInput.value = country;
  }

  getCurrentLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const userPos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          };

          this.map.setCenter(userPos);
          this.draggableMarker.position = userPos;
          
          // Initialise both coordinate fields and address field updates
          this.updateCoordinatesUI();
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
