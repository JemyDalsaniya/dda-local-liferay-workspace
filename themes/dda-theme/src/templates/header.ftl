<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Website Header</title>
    <link rel="stylesheet" href="${css_folder}/main.scss" />
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<section class="top-header" id="background-container">
  <div class="container-fluid">
  <div class="custom-gap">
    <header class="header">
        <img src="${themeDisplay.getPathThemeImages()}/header/DubaiGov_logo.png" alt="Logo" class="logo">
        <nav class="navbar navbar-expand-xl">
             <button
                class="navbar-toggler"
                type="button"
                data-toggle="collapse"
                data-target="#navbarCollapse"
                aria-controls="navbarCollapse"
                aria-expanded="false"
                aria-label="Toggle navigation"
            >
                <span class="navbar-toggler-icon"></span>
            </button>
             <div class="collapse navbar-collapse" id="navbarCollapse">
            <ul class="nav-menu navbar-nav mr-auto">
                <li><a href="#">Home</a></li>
                <li><a href="#">About Us</a></li>
                <li>
                <a href="http://localhost:8083/services">Data & Statistics</a>
                </li>
                <li><a href="#">Marketplace</a></li>
                <li><a href="#">Tools & Services</a></li>
            </ul>
            <div class="responsive-right">
                  <ul>
               
                <li> <a href="#"> <i id="accessibility-icon" class="fa-brands fa-accessible-icon" style="font-size: 20px; margin-right: 10px;"></i> </a> </li>
                <li> 
                    <button class="language-select">
                        العربية
                    </button>
                </li>
                <li>
                    <#if themeDisplay.isSignedIn()>
                        <a href="/c/portal/logout" class="auth-btn">Logout</a>
                    </#if>
                    <#if !themeDisplay.isSignedIn()>
                        <a href="javascript:void(0);" class="auth-btn">Login</a>
                    </#if>
                </li>
               
            </ul>
            <a href="#"><img src="${themeDisplay.getPathThemeImages()}/header/DubaiGov_logo.png" alt="Logo" class="logo"></a>
            </div>
            </div>
        </nav>
        <div class="right-section"> 
            <ul>
                <li><a href="#"> <i class="fa-solid fa-magnifying-glass icon-design" style="font-size: 17px; margin: 10px"></i> </a> </li>
                <li> <a href="#"> <i id="accessibility-icon" class="fa-brands fa-accessible-icon" style="font-size: 20px; margin-right: 10px;"></i> </a> </li>
                <li> 
                    <button class="language-select">
                        العربية
                    </button>
                </li>
                <li>
                    <#if themeDisplay.isSignedIn()>
                        <a href="/c/portal/logout" class="auth-btn">Logout</a>
                    </#if>
                    <#if !themeDisplay.isSignedIn()>
                        <a href="javascript:void(0);" class="auth-btn">Login</a>
                    </#if>
                </li>
                <li>
                <a href="#">
                <img src="${themeDisplay.getPathThemeImages()}/header/digital-dubai-colored.png" alt="Right Logo" class="right-logo" style="max-width:111px">
                </a>
                </li>
            </ul>
            
        </div>
    </header>
    <div id="accessibility-panel">
        <div class="accessibility-section">
            <p>Text resize:</p>
            <button onclick="resizeText('increase')">A+</button>
            <button onclick="resizeText('decrease')">A-</button>
        </div>
        <div class="accessibility-section">
            <p>Contrast switch:</p>
            <label><input type="radio" name="contrast" onclick="switchContrast('default')" checked> DEWA colors</label>
            <label><input type="radio" name="contrast" onclick="switchContrast('color-blind')"> Colour blind</label>
            <label><input type="radio" name="contrast" onclick="switchContrast('green-weakness')"> Green weakness</label>
            <label><input type="radio" name="contrast" onclick="switchContrast('red-weakness')"> Red weakness</label>
        </div>
        <div class="accessibility-section">
            <p>Sign Language Interpreter:</p>
            <label class="switch">
                <input type="checkbox" onclick="toggleSignLanguageInterpreter()">
                <span class="slider round"></span>
            </label>
        </div>
        <div class="accessibility-section">
            <p>Read Speaker:</p>
            <button onclick="toggleReadSpeaker()">Listen to this page</button>
        </div>
    </div>
</div>
  </div>
</section>
<!-- Modal Structure -->
<div id="loginModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <@liferay_portlet["runtime"] portletName="com_liferay_login_web_portlet_LoginPortlet" />
    </div>
</div>
<script>

    var modal = document.getElementById("loginModal");
    var btn = document.querySelector(".login-btn");
    var span = document.getElementsByClassName("close")[0];
    btn.onclick = function() {
        modal.style.display = "block";
    }
    span.onclick = function() {
        modal.style.display = "none";
    }
    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }

    document.getElementById('accessibility-icon').addEventListener('click', function() {
        var panel = document.getElementById('accessibility-panel');
        if (panel.style.display === 'none' || panel.style.display === '') {
            panel.style.display = 'block';
        } else {
            panel.style.display = 'none';
        }
    });

    function resizeText(action) {
        var elements = document.querySelectorAll('body, body *');
        elements.forEach(function(element) {
            var currentSize = window.getComputedStyle(element, null).getPropertyValue('font-size');
            var newSize;
            if (action === 'increase') {
                newSize = parseFloat(currentSize) + 1;
            } else {
                newSize = parseFloat(currentSize) - 1;
            }
            element.style.fontSize = newSize + 'px';
        });
    }

    function switchContrast(mode) {
        console.log("switch contrast called....")
        var container = document.getElementById('background-container');
        console.log("container" + container)
        container.classList.remove('default-contrast', 'color-blind-contrast', 'green-weakness-contrast', 'red-weakness-contrast');
        console.log("all class removed")
        if (mode === 'default') {
            console.log("default")
            container.classList.add('default-contrast');
        } else if (mode === 'color-blind') {
            console.log("color-blind")
            container.classList.add('color-blind-contrast');
        } else if (mode === 'green-weakness') {
            console.log("green-weakness")
            container.classList.add('green-weakness-contrast');
        } else if (mode === 'red-weakness') {
            console.log("red-weakness")
            container.classList.add('red-weakness-contrast');
        }
    }

    function toggleSignLanguageInterpreter() {
        alert('Sign Language Interpreter toggled (placeholder)');
    }

    function toggleReadSpeaker() {
        alert('Read Speaker toggled (placeholder)');
    }
</script>
<#--    <script src="../js/bootstrap.min.js"></script>-->
<#--    <script src="../js/jquery-3.3.1.slim.min.js"></script>-->
</body>
</html>
