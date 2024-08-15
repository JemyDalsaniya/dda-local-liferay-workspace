document.addEventListener("DOMContentLoaded", function () {
    // Function to download all documentation as a ZIP file
    function downloadAllDocumentation() {
        if (attachments.length === 0) {
            alert("No attachments available to download.");
            return;
        }

        const zip = new JSZip();

        // Fetch all files and add them to the ZIP archive
        const fetchPromises = attachments.map(file => {
            return fetch(file.url)
                .then(response => response.blob())
                .then(blob => {
                    zip.file(file.name, blob);
                });
        });

        // When all files are fetched, generate the ZIP and trigger download
        Promise.all(fetchPromises)
            .then(() => zip.generateAsync({ type: 'blob' }))
            .then(blob => {
                saveAs(blob, 'documentation.zip');
            })
            .catch(error => {
                console.error("Failed to download files: ", error);
            });
    }

    // Show More / Show Less button functionality
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

    // Toggle icon functionality for accordions
    document.querySelectorAll('.toggle-icon').forEach(button => {
        button.addEventListener('click', function (event) {
            event.preventDefault();
            const icon = button.querySelector('.icon');
            const collapseTarget = document.querySelector(button.getAttribute('data-target'));

            if (collapseTarget.classList.contains('show')) {
                icon.textContent = '+';
            } else {
                icon.textContent = '-';
            }
        });
    });
});
