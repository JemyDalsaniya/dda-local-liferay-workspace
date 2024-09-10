// This script is used for handling pagination, tab navigation, form validation, and order details display
$(document).ready(function () {
    // Pagination settings
    const itemsPerPage = 2; // Number of items per page
    const items = document.querySelectorAll('.item');
    const totalPages = Math.ceil(items.length / itemsPerPage);
    let currentPage = 1;

    const prevButton = document.getElementById('prev');
    const nextButton = document.getElementById('next');
    const pageNumbers = document.getElementById('page-numbers');

    if (prevButton && nextButton && pageNumbers) { // Check if elements exist
        // Function to display a specific page of items
        function showPage(page) {
            // Hide all items
            items.forEach((item) => {
                item.style.display = 'none';
            });

            // Show the selected page of items
            const start = (page - 1) * itemsPerPage;
            const end = start + itemsPerPage;
            for (let i = start; i < end; i++) {
                if (items[i]) {
                    items[i].style.display = 'block';
                }
            }

            // Disable/Enable buttons based on the current page
            prevButton.disabled = page === 1;
            nextButton.disabled = page === totalPages;
        }

        // Function to update page number buttons
        function updatePageNumbers() {
            // Clear existing page numbers
            pageNumbers.innerHTML = '';

            // Create page number buttons
            for (let i = 1; i <= totalPages; i++) {
                const pageNumberButton = document.createElement('button');
                pageNumberButton.textContent = i;
                pageNumberButton.className = 'page-number';
                pageNumberButton.addEventListener('click', function () {
                    currentPage = i;
                    showPage(currentPage);
                    updatePageNumbers();
                });
                // Highlight the current page number
                if (i === currentPage) {
                    pageNumberButton.classList.add('active'); // Highlight the current page
                }

                pageNumbers.appendChild(pageNumberButton);
            }
        }

        // Add event listeners for pagination buttons
        prevButton.addEventListener('click', function () {
            if (currentPage > 1) {
                currentPage--;
                showPage(currentPage);
                updatePageNumbers();
            }
        });

        nextButton.addEventListener('click', function () {
            if (currentPage < totalPages) {
                currentPage++;
                showPage(currentPage);
                updatePageNumbers();
            }
        });

        // Initialize pagination
        showPage(currentPage);
        updatePageNumbers();
    }

    // Function to activate the correct tab based on URL hash or default to 'personal' tab
    function activateTabFromHash() {
        var hash = "";
        if (activeTab === 'personal') {
            hash = "#nav-personal";
        }
        else if(activeTab === 'orderhistory') {
           hash = "#nav-order";
        }
        else {
            hash = window.location.hash;
        }
        const $navTab = $('#nav-tab');
        const $tabContent = $('#nav-tabContent');
        const $inboxTab = $('#nav-inbox-tab');
        const $inboxPane = $('#nav-inbox');

        // Deactivate all main tabs and panes
        $navTab.find('a.nav-link').removeClass('active').removeAttr('aria-selected');
        $tabContent.children('.tab-pane').removeClass('active show');

        if (hash) {
            const $targetTab = $navTab.find(`a[href="${hash}"]`);
            const $targetPane = $(hash);

            if ($targetTab.length && $targetPane.length) {
                $targetTab.addClass('active').attr('aria-selected', 'true');
                $targetPane.addClass('active show');

                if (hash === '#nav-inbox') {
                    activateNestedTab(localStorage.getItem('activeInboxTab') || '#nav-service');
                }
            }
        } else {
            $inboxTab.addClass('active').attr('aria-selected', 'true');
            $inboxPane.addClass('active show');
            activateNestedTab('#nav-service');
        }
    }

    // Function to activate nested tabs within the inbox
    function activateNestedTab(tabId) {
        const $inbox = $('#nav-inbox');
        const $nestedTabs = $inbox.find('.nav-tabbs a');
        const $nestedPanes = $inbox.find('.tab-content > .tab-pane');

        // Deactivate all nested tabs and panes
        $nestedTabs.removeClass('active').removeAttr('aria-selected');
        $nestedPanes.removeClass('active show');

        // Activate the specified nested tab
        const $targetNestedTab = $nestedTabs.filter(`[href="${tabId}"]`);
        $targetNestedTab.addClass('active').attr('aria-selected', 'true');
        $(tabId).addClass('active show');

        // Store the active nested tab
        localStorage.setItem('activeInboxTab', tabId);
    }

    // Activate the correct tab on page load
    activateTabFromHash();

    // Handle main tab clicks
    $('#nav-tab').on('click', 'a', function (e) {
        e.preventDefault();
        history.pushState(null, null, $(this).attr('href'));
        activateTabFromHash();
    });

    // Handle nested tab clicks within inbox
    $('#nav-inbox').on('click', '.nav-tabbs a', function (e) {
        e.preventDefault();
        activateNestedTab($(this).attr('href'));
    });

    // Handle browser back/forward buttons
    $(window).on('popstate', activateTabFromHash);
});

// Handles the display of order details when the 'View Order Detail' button is clicked
document.querySelectorAll('.view-order-detail').forEach(button => {
    closeAllDropdowns();
    button.addEventListener('click', function() {
        const order = this.dataset.order;
        const contextPath = this.dataset.contextPath;
        viewOrderDetails(order, contextPath); // Call function to display order details
    });
});

// Validates the user details form before submission
document.getElementById('userDetailsForm').addEventListener('submit', async function(event) {
    event.preventDefault(); // Prevent form submission by default

    var isValid = true;

    var firstNameInput = document.getElementById('inputfirstname');
    if (firstNameInput.value.trim() === '') {
        document.getElementById('firstNameError').textContent = localizedErrorMessages.firstNameError;
        isValid = false;
    } else {
        document.getElementById('firstNameError').textContent = "";
    }

    var cityInput = document.getElementById('inputcity');
    if (cityInput.value.trim() === '') {
        document.getElementById('cityError').textContent = localizedErrorMessages.cityError;
        isValid = false;
    } else {
        document.getElementById('cityError').textContent = "";
    }

    // Last Name validation
    var lastNameInput = document.getElementById('inputlastname');
    if (lastNameInput.value.trim() === '') {
        document.getElementById('lastNameError').textContent = localizedErrorMessages.lastNameError;
        isValid = false;
    } else {
        document.getElementById('lastNameError').textContent = "";
    }

    // Date of Birth validation
    var dobInput = document.getElementById('inputdateofbirth');
    var dob = new Date(dobInput.value);
    var today = new Date();
    if (dob > today) {
        document.getElementById('dobError').textContent = localizedErrorMessages.dobError;
        isValid = false;
    } else {
        document.getElementById('dobError').textContent = "";
    }

    // Mobile Number validation
    var mobileInput = document.getElementById('inputmobilenumber');
    var mobileRegex = /^[0-9]{10}$/; // Assumes 10-digit number, adjust as needed
    if (!mobileRegex.test(mobileInput.value)) {
        document.getElementById('phoneError').textContent = localizedErrorMessages.phoneError;
        isValid = false;
    } else {
        document.getElementById('phoneError').textContent = "";
    }

    // Address validation
    var addressInput = document.getElementById('inputaddress');
    if (addressInput.value.trim().length < 5) { // Minimum 5 characters
        document.getElementById('addressError').textContent = localizedErrorMessages.addressError;
        isValid = false;
    } else {
        document.getElementById('addressError').textContent = "";
    }

    // Screen Name Validation
    var screenName = document.getElementById('inputscreenname').value.trim();

    // Reserved words list
    const reservedWords = ['postfix']; // Add any other reserved words here

    // Regular expression to check if screen name contains only alphanumeric characters or -._ and no @
    const screenNameRegex = /^[a-zA-Z0-9._-]+$/;

    // Check if screen name is an email address
    if (screenName ==='' || screenName.includes('@') || reservedWords.includes(screenName.toLowerCase()) || !screenNameRegex.test(screenName)) {
        document.getElementById('screenNameError').textContent = localizedErrorMessages.screenNameError;
        isValid = false;
    }
    else {
        document.getElementById('screenNameError').textContent = "";
        var formData = new FormData();
        formData.append(namespace + 'userId', userId);
        formData.append(namespace + 'screenName', screenName);

        try {
            let response = await fetch(resourceURL, {
                method: 'POST',
                body: formData
            });
            let data = await response.json();
            if (data.exists) {
                document.getElementById('ScreenNameAlreadyExists').textContent = localizedErrorMessages.ScreenNameAlreadyExists;
                isValid = false;
            } else {
                document.getElementById('ScreenNameAlreadyExists').textContent = "";
            }
        } catch (error) {
            console.error('Error fetching screenName:', error);
            console.error('Error details:', error.message);
            isValid = false;
        }
    }

    // If all validations pass, submit the form
    if (isValid) {
        this.submit();
    }
});

// Add event listeners to all elements with class 'three-dots'
document.querySelectorAll('.three-dots').forEach(dots => {
    dots.addEventListener('click', function(e) {
      e.stopPropagation(); // Prevent event from bubbling up
      const dropdownMenu = this.closest('.dropdown').querySelector('.dropdown-menu');
      closeAllDropdowns();
      dropdownMenu.classList.toggle('show');
    });
  });
// Add event listener to the document to close all dropdowns when clicking outside
document.addEventListener('click', closeAllDropdowns);

// Function to close all open dropdown menus
function closeAllDropdowns() {
  document.querySelectorAll('.dropdown-menu.show').forEach(menu => {
    menu.classList.remove('show');
  });
}

// Function to display order details
function viewOrderDetails(orderJson, contextPath) {
    const order = JSON.parse(orderJson);
    const languageId = themeDisplay.getLanguageId();

    if (order) {
        var detailsHtml = `
            <div class="container-fluid">
              <div class="row">
                <div class="col-lg-12">
                  <div class="history-back">
                  <a href="#" onclick="hideOrderDetails(); return false;" class="text-decoration-none d-flex">
                      <img class="mr-2" src="${contextPath}/images/left-arrow.png" alt="" />
                      <h5>${localizedMessages.backOrderHistory}</h5>
                    </a>
                  </div>
                </div>
              </div>
              <div class="row mt-3">
                <div class="col-lg-9">
                  <div class="d-flex">
                    <img src="${order.productImageUrl}" alt="Thumbnail" class="img-fluid" style="width: 85px; height: 65px;"/>
                    <div class="mx-4">
                      <h1 class="font-weight-bold">${order.productName}</h1>
                      <p>
                        ${order.productDescription}
                      </p>
                    </div>
                  </div>
                </div>
                <div class="col-lg-3">
                  <div class="">
                    <div class="d-flex">
                      <div class="d-flex col-lg-5">
                        <h6 class=""><b class="">${localizedMessages.orderId}:</b></h6>
                      </div>
                      <div class="col-lg-7">
                        <p class="ml-auto">${order.orderId}</p>
                      </div>
                    </div>
                  </div>

                  <div class="">
                    <div class="d-flex">
                      <div class="d-flex col-lg-5">
                        <h6 class=""><b class="">${localizedMessages.startDate}:</b></h6>
                      </div>
                      <div class="col-lg-7">
                        <p class="ml-auto">${order.date}</p>
                      </div>
                    </div>
                  </div>

                  <div class="">
                    <div class="d-flex">
                      <div class="d-flex col-lg-5">
                        <h6 class=""><b class="">${localizedMessages.status}</b></h6>
                      </div>
                      <div class="col-lg-7">
                        <div class="order-status">
                          <p class="text-center py-1">${order.status}</p>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <hr />

            <div class="container-fluid">
              <div class="border rounded mt-5">
                <div class="row">
                  <div class="col-lg-12">
                    <div class="mx-3 my-2">
                      <h4>${localizedMessages.orderDetails}</h4>
                      <p>${localizedMessages.orderDescription}</p>
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="table-order col-lg-12 table-order col-sm-12 mb-4">
                    <table class="table table-order">
                      <thead>
                        <tr class="">
                          <th scope="col">${localizedMessages.detail}</th>
                          <th scope="col">${localizedMessages.value}</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td scope="row">${localizedMessages.subscriptionType}</td>
                          <td>${localizedMessages.bronze}</td>
                        </tr>
                        <tr>
                          <td scope="row">${localizedMessages.numberOfQuantity}</td>
                          <td>${order.quantity}</td>
                        </tr>
                        <tr>
                          <td scope="row">${localizedMessages.endDate}</td>
                          <td>${order.date}</td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>

            <div class="container-fluid">
              <div class="border rounded my-5">
                <div class="row">
                  <div class="col-lg-12">
                    <div class="mx-3 my-2">
                      <h4>${localizedMessages.productInformation}</h4>
                      <p>${localizedMessages.orderDescription}</p>
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-lg-12 table-order col-sm-12 mb-4">
                    <table class="table table-order">
                      <thead>
                        <tr class="">
                          <th scope="col">${localizedMessages.detail}</th>
                          <th scope="col">${localizedMessages.value}</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td scope="row">${localizedMessages.url}</td>
                          <td>www.google.com</td>
                        </tr>
                        <tr>
                          <td scope="row">${localizedMessages.apiKey}</td>
                          <td>ak.asndaksmdaskdasjndasw1271</td>
                        </tr>
                        <tr>
                          <td scope="row">${localizedMessages.secret}</td>
                          <td>sk.asdkjasdawqq23618sas</td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>

            <div class="container-fluid payment-history">
              <div class="mb-4">
                <h3 class="font-weight-bold">${localizedMessages.paymentHistory}</h3>
              </div>
              <table class="table table-empty border">
                <tbody>
                  <tr class="">
                    <td class="text-center">${localizedMessages.noDataFound}</td>
                  </tr>
                </tbody>
              </table>

            </div>
        `;

        // Insert the constructed HTML into the order details section
        document.getElementById('orderDetailsSection').innerHTML = detailsHtml;
        // Hide order history section and show order details section
        document.getElementById('order-history').style.display = 'none';
        document.getElementById('orderDetailsSection').style.display = 'block';
    }
}

// Function to hide the order details and show the order history section
function hideOrderDetails() {
  document.getElementById('order-history').style.display = '';
  document.getElementById('orderDetailsSection').style.display = 'none';
    // Get all tab panes and deactivate them
    var tabPanes = document.querySelectorAll('.tab-pane');
    tabPanes.forEach(function(pane) {
        pane.classList.remove('active', 'show');
    });

    // Get all nav tabs and deactivate them
    var navTabs = document.querySelectorAll('.nav-tabs .nav-link');
    navTabs.forEach(function(tab) {
        tab.classList.remove('active');
        tab.setAttribute('aria-selected', 'false');
    });

    // Activate the order history tab and its content
    var orderTab = document.getElementById('nav-order-tab');
    var orderPane = document.getElementById('nav-order');

    if (orderTab && orderPane) {
        orderTab.classList.add('active');
        orderTab.setAttribute('aria-selected', 'true');
        orderPane.classList.add('active', 'show');
    }

    // Update the URL hash
    history.pushState(null, null, '#nav-order');
}

