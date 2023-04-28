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
    console.log("Bid button clicked for vehicle ID:", vehicleId, "and seller ID:", sellerId);
}  

function handleDeleteButtonClick(vehicleId, sellerId, dt) {
    const xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState === 4 && this.status === 200) {
            location.reload(); // Refresh the page after a successful delete
        }
    };
    xhttp.open("GET", `delete.jsp?vehicle_id=${vehicleId}&seller_id=${encodeURIComponent(sellerId)}&dt=${encodeURIComponent(dt)}`, true);
    xhttp.send();
}