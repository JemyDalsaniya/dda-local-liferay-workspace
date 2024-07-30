<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Website Header</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #333;
            color: #fff;
        }

        .background-container {
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            min-height: 20vh;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 5%;
            background-color: rgba(255, 255, 255, 0.8);
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            margin: 20px auto;
            border-radius: 15px;
            backdrop-filter: blur(5px);
            width: 82%;
            height: 65px;
            position: relative;
        }

        .logo {
            height: 50px;
            width: 130px;
        }

        .nav-menu {
            display: flex;
            list-style-type: none;
            padding: 0;
            margin: 0 100px;
        }

        .nav-menu li {
            position: relative; /* Ensure that the dropdown items are positioned relative to the parent */
            margin: 0 20px;
        }

        .nav-menu a {
            text-decoration: none;
            color: black;
            position: relative;
        }

        .nav-menu a:hover {
            color: #0066cc;
        }

        .nav-menu a::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 2px;
            bottom: -5px;
            left: 0;
            background-color: #0066cc;
            visibility: hidden;
            transform: scaleX(0);
            transition: all 0.3s ease-in-out;
        }

        .nav-menu a:hover::after {
            visibility: visible;
            transform: scaleX(1);
        }

        .right-section {
            display: flex;
            align-items: center;
        }

        .search-icon, .language-select, .login-btn, .right-logo {
            margin-left: 10px;
        }

        .login-btn {
            background-color: transparent;
            color: black;
            padding: 5px 10px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }

        .icon-design {
            margin: 10px;
            cursor: pointer;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #f9f9f9;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
            z-index: 1;
            border-radius: 5px;
        }

        .dropdown-content a {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
        }

        .dropdown-content a:hover {
            background-color: #f1f1f1;
        }

        .nav-menu li:hover .dropdown-content {
            display: block;
        }

        #accessibility-panel {
            display: none;
            background-color: #333;
            color: white;
            padding: 20px;
            position: absolute;
            top: 70px;
            right: 20px;
            z-index: 1000;
            border-radius: 10px;
            width: 600px;
            box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
        }

        .accessibility-section {
            margin-bottom: 20px;
        }

        .accessibility-section p {
            margin: 0;
            margin-bottom: 10px;
            font-weight: bold;
        }

        .accessibility-section button,
        .accessibility-section input {
            margin-right: 10px;
        }

        .default-contrast {
            background-color: white;
            color: black;
        }

        .color-blind-contrast {
            background-color: #f1f1f1 !important;
            color: #000000 !important;
        }

        .green-weakness-contrast {
            background-color: #d2f8d2 !important;
            color: #005700 !important;
        }

        .red-weakness-contrast {
            background-color: #f8d2d2 !important;
            color: #570000 !important;
        }

        .switch {
            position: relative;
            display: inline-block;
            width: 34px;
            height: 20px;
        }

        .switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 34px;
        }

        .slider:before {
            position: absolute;
            content: "";
            height: 14px;
            width: 14px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }

        input:checked + .slider {
            background-color: #2196F3;
        }

        input:checked + .slider:before {
            transform: translateX(14px);
        }

        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4);
            padding-top: 60px;
        }

        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 35%;
            position: relative;
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<#if show_header>
    <header id="banner">
        <div class="navbar navbar-classic navbar-top py-3">
            <div class="container-fluid container-fluid-max-xl user-personal-bar">
                <div class="align-items-center autofit-row">
                    <a class="${logo_css_class} align-items-center d-md-inline-flex d-sm-none d-none logo-md"
                       href="${site_default_url}"
                       title="<@liferay.language_format arguments="${site_name}" key="go-to-x" />">
                        <img alt="${logo_description}" class="mr-2" height="56" src="${site_logo}"/>

                        <#if show_site_name>
                            <h1 <#if show_control_menu>aria-hidden="true"</#if>
                                class="font-weight-bold h2 mb-0 text-dark">${site_name}</h1>
                        </#if>
                    </a>

                    <#assign preferences = freeMarkerPortletPreferences.getPreferences({"portletSetupPortletDecoratorId": "barebone", "destination": "/search"}) />

                    <div class="autofit-col autofit-col-expand">
                        <#if show_header_search>
                            <div class="justify-content-md-end mr-4 navbar-form" role="search">
                                <@liferay.search_bar default_preferences="${preferences}" />
                            </div>
                        </#if>
                    </div>

                    <div class="autofit-col">
                        <@liferay.user_personal_bar />
                    </div>
                </div>
            </div>
        </div>

        <div class="navbar navbar-classic navbar-expand-md navbar-light pb-3">
            <div class="container-fluid container-fluid-max-xl">
                <a class="${logo_css_class} align-items-center d-inline-flex d-md-none logo-xs"
                   href="${site_default_url}" rel="nofollow">
                    <img alt="${logo_description}" class="mr-2" height="56" src="${site_logo}"/>

                    <#if show_site_name>
                        <h2 <#if show_control_menu>aria-hidden="true"</#if>
                            class="font-weight-bold h2 mb-0 text-dark">${site_name}</h2>
                    </#if>
                </a>

                <#include "${full_templates_path}/navigation.ftl" />
            </div>
        </div>
    </header>
</#if>


<div class="background-container" id="background-container">
    <header class="header">
        <img src="${themeDisplay.getPathThemeImages()}/header/DubaiGov_logo.png" alt="Logo" class="logo">
        <nav>
            <ul class="nav-menu">
                <li><a href="#">Home</a></li>
                <li><a href="#">About Us</a></li>
                <li>
                    <a href="#">Data ▼</a>
                    <div class="dropdown-content">
                        <a href="http://localhost:8083/services">Services</a>
                    </div>
                </li>
                <li>
                    <a href="#">Statistics ▼</a>
                    <div class="dropdown-content">
                        <a href="http://localhost:8083/services">Statistics Services</a>
                    </div>
                </li>
                <li><a href="#">Marketplace</a></li>
                <li><a href="#">Services</a></li>
            </ul>
        </nav>
        <div class="right-section">
            <i class="fa-solid fa-magnifying-glass icon-design" style="font-size: 17px; margin: 10px"></i>
            <i id="accessibility-icon" class="fa-brands fa-accessible-icon"
               style="font-size: 20px; margin-right: 10px;"></i>
            <select class="language-select">
                <option>English</option>
                <option>العربية</option>
            </select>
            <#if themeDisplay.isSignedIn()>
                <a href="/c/portal/logout" class="login-btn">Logout</a>
            </#if>
            <#if !themeDisplay.isSignedIn()>
                <a href="javascript:void(0);" class="login-btn">Login</a>
            </#if>
            <img src="${themeDisplay.getPathThemeImages()}/header/digital-dubai-colored.png" alt="Right Logo"
                 class="right-logo" style="height: 60px; width:120px;">
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
            <label><input type="radio" name="contrast" onclick="switchContrast('green-weakness')"> Green
                weakness</label>
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
    btn.onclick = function () {
        modal.style.display = "block";
    }
    span.onclick = function () {
        modal.style.display = "none";
    }
    window.onclick = function (event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }

    document.getElementById('accessibility-icon').addEventListener('click', function () {
        var panel = document.getElementById('accessibility-panel');
        if (panel.style.display === 'none' || panel.style.display === '') {
            panel.style.display = 'block';
        } else {
            panel.style.display = 'none';
        }
    });

    function resizeText(action) {
        var elements = document.querySelectorAll('body, body *');
        elements.forEach(function (element) {
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
</body>
</html>
