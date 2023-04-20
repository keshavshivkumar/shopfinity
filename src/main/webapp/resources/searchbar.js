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
        }
    };
    xhttp.open("GET", "fetchdata.jsp?query=" + query, true);
    xhttp.send();
}
