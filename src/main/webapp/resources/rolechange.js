function changeRole(email, role_id) {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            // Refresh the page when the request is successful
            location.reload();
        }
    };
    xhttp.open("GET", "changerole.jsp?email=" + email + "&role_id=" + role_id, true);
    xhttp.send();
}