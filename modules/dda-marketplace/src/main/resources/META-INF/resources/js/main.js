//Download all documents
function downloadAllDocumentation() {
    if (attachments.length === 0) {
        alert("No attachments available to download.");
        return;
    }

    var zip = new JSZip();

    // Fetch all files and add them to the ZIP archive
    var fetchPromises = attachments.map(function (file) {
        return fetch(file.url)
            .then(function (response) {
                return response.blob();
            })
            .then(function (blob) {
                zip.file(file.name, blob);
            });
    });

    // When all files are fetched, generate the ZIP and trigger download
    Promise.all(fetchPromises).then(function () {
        zip.generateAsync({type: 'blob'}).then(function (blob) {
            saveAs(blob, 'documentation.zip');
        });
    }).catch(function (error) {
        console.error("Failed to download files: ", error);
    });
}

// Show More / Show Less button functionality
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.show-more').forEach(button => {
        button.addEventListener('click', function (event) {
            event.preventDefault();
            const tabPane = button.closest('.tab-pane');
            const additionalRows = tabPane.querySelectorAll('.additional-row');
            const showMoreText = button.getAttribute('data-show-more');
            const showLessText = button.getAttribute('data-show-less');

            if (button.textContent.trim() === showMoreText) {
                additionalRows.forEach(row => {
                    row.classList.remove('d-none');
                });
                button.textContent = showLessText;
            } else {
                additionalRows.forEach(row => {
                    row.classList.add('d-none');
                });
                button.textContent = showMoreText;
            }
        });
    });
});


$(document).ready(function() {
    //Manage buy button based on terms and conditions
    const $agreeTermsCheckbox = $('#agreeTerms');
    const $buyButton = $('#buyButton');

    function toggleBuyButton() {
        const isDisabled = !$agreeTermsCheckbox.is(':checked');
        $buyButton.toggleClass('disabled', isDisabled).attr('aria-disabled', isDisabled);
    }

    $agreeTermsCheckbox.change(toggleBuyButton);

    $buyButton.click(function (event) {
        if ($buyButton.hasClass('disabled')) {
            event.preventDefault();
        } else {
            storeSelectedValues();
        }
    });

    // Initialize button state on page load
    toggleBuyButton();

    //show order success and failure popup
    updateBuyButtonURL();

    const isOrderCreated = $('#modal-content-data').data('value');
    if (isOrderCreated) {
        $('#resultModal').modal('show');
    } else {
        console.log('Order was not created');
    }

    $('.close-model').click(function() {
        $('#resultModal').modal('hide');
    });

    // Retrieve stored values and set them in the form
    var storedSubscriptionType = sessionStorage.getItem('selectedSubscriptionType');
    var storedPackage = sessionStorage.getItem('selectedPackage');

    if (storedSubscriptionType) {
        $('#subscriptionType').val(storedSubscriptionType);
    }
    if (storedPackage) {
        $('#package').val(storedPackage);
    }

    // Trigger change event to update price
    $('#subscriptionType, #package').trigger('change');

    // Clear session storage
    sessionStorage.removeItem('selectedSubscriptionType');
    sessionStorage.removeItem('selectedPackage');

    // Initialize buy button URL
    updateBuyButtonURL();
});

function storeSelectedValues() {
    sessionStorage.setItem('selectedSubscriptionType', $('#subscriptionType').val());
    sessionStorage.setItem('selectedPackage', $('#package').val());
}

// Add event listeners to store values on change
$('#subscriptionType, #package').change(storeSelectedValues);

(function() {
    let isFirstLoad = true;

    function initializeEventListeners() {
        var subscriptionTypeElement = document.getElementById('subscriptionType');
        var packageElement = document.getElementById('package');

        if (subscriptionTypeElement && packageElement) {
            subscriptionTypeElement.addEventListener('change', handleChange);
            packageElement.addEventListener('change', handleChange);
            updatePrice(); // Call updatePrice manually once to set the initial price
        } else {
            console.error('Required elements not found');
        }
    }

    function handleChange() {
        isFirstLoad = false;
        updatePrice();
    }

    function updatePrice() {
        let sku;
        const subscriptionTypeElement = document.getElementById('subscriptionType');
        const packageTypeElement = document.getElementById('package');
        const productId = document.getElementById('productId').value;

        const packageType = sessionStorage.getItem('selectedPackage') || packageTypeElement.value;

        if (packageType === "pay-as-you-go" || packageType === "one-time-payment") {
            subscriptionTypeElement.disabled = true;
            sku = packageType;
        } else {
            subscriptionTypeElement.disabled = false;
            const subscriptionType = sessionStorage.getItem('selectedSubscriptionType') || subscriptionTypeElement.value;
            sku = subscriptionType + "-" + packageType;
        }

        // Construct the full URL with namespaced parameters
        var fullURL = $('#priceUrl').data('url') + '&' + $('#namespace').data('value') + 'sku=' + encodeURIComponent(sku) + '&' + $('#namespace').data('value') + 'productId=' + encodeURIComponent(productId);

        // Make an AJAX request to get the price based on the SKU and product
        fetch(fullURL)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.statusText);
                }
                return response.text();
            })
            .then(text => {
                return JSON.parse(text);
            })
            .then(data => {
                // Update the price display on the page
                if (data.price) {
                    document.getElementById('priceDisplay').innerHTML = data.price + ' ' + $('#aedMessage').data('value');
                } else {
                    console.error("Price data not found in response");
                }
            })
            .catch(error => {
                console.error('Error fetching price:', error);
                console.error('Error details:', error.message);
            });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initializeEventListeners);
    } else {
        initializeEventListeners();
    }
})();

function updateBuyButtonURL() {
    var buyButton = $('#buyButton');
    var subscriptionTypeSelect = $('#subscriptionType');
    var packageSelect = $('#package');
    var createOrderURL = $('#createOrderUrl').data('url');

    if (buyButton.length) {
        var subscriptionType = subscriptionTypeSelect.val();
        var packageType = packageSelect.val();

        var updatedURL = createOrderURL +
            '&' + $('#namespace').data('value') + 'subscriptionType=' + encodeURIComponent(subscriptionType) +
            '&' + $('#namespace').data('value') + 'packageType=' + encodeURIComponent(packageType);

        buyButton.attr('href', updatedURL);
    }
}

$('#subscriptionType, #package').on('change', updateBuyButtonURL);




