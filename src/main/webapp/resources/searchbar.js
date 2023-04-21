function searchFunction() {
    const searchInput = document.getElementById("search-input");
    const query = searchInput.value;
    const searchResults = document.getElementById("search-results");

    if (query.length === 0) {
        searchResults.innerHTML = "";
        return;
    }

    const xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            searchResults.innerHTML = this.responseText;
            const bidButtons = searchResults.querySelectorAll("button[id^='bid-button-']");
            bidButtons.forEach((button) => {
            button.addEventListener("click", () => {
                const vehicleId = button.getAttribute("data-vehicle-id");
                const sellerId = button.getAttribute("data-seller-id");
                handleBidButtonClick(vehicleId, sellerId);
                });
            });
        }
    };
    xhttp.open("GET", "fetchdata.jsp?query=" + query, true);
    xhttp.send();
}

function handleBidButtonClick(vehicleId, sellerId) {
    // Do something with the vehicleId and sellerId, e.g., show a bid form or send a request to the server
    console.log("Bid button clicked for vehicle ID:", vehicleId, "and seller ID:", sellerId);
}  