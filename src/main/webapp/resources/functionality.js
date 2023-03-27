const passwordField = document.getElementById("password");
const passwordRequirements = document.getElementById("password-requirements");
const showPasswordCheckbox = document.getElementById("show-password");

passwordField.addEventListener("focus", () => {
  passwordRequirements.style.display = "block";
});

passwordField.addEventListener("blur", () => {
  passwordRequirements.style.display = "none";
});

passwordField.addEventListener("input", () => {
  const password = passwordField.value;
  const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$])(?=.*[0-9])[a-zA-Z0-9@#$]{8,}$/;
  if (passwordRegex.test(password)) {
    passwordRequirements.style.color = "green";
    passwordRequirements.textContent = "Password requirements met!";
    setTimeout(() => {
      passwordRequirements.textContent = "";
    }, 2000);
  } else {
    passwordRequirements.style.color = "red";
    passwordRequirements.innerHTML = "Password must be:<br>- at least 8 characters long<br>- have a combination of lowercase & uppercase letter<br>- have one special character (@#$)";
  }
});

showPasswordCheckbox.addEventListener("change", function () {
  if (showPasswordCheckbox.checked) {
    passwordField.type = "text";
  } else {
    passwordField.type = "password";
  }
});