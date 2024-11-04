document.getElementById('download-button').addEventListener('click', function() {
    const repo = 'pauloricardo-ggs/CommandCaster';
    const assetPrefix = 'CommandCasterInstaller';

    fetch(`https://api.github.com/repos/${repo}/releases/latest`)
        .then(response => response.json())
        .then(data => {
            const asset = data.assets.find(asset => asset.name.startsWith(assetPrefix));
            if (asset) {
                window.location.href = asset.browser_download_url;
            } else {
                alert('Latest version not found.');
            }
        })
        .catch(error => {
            console.error('Error fetching latest release:', error);
            alert('Failed to fetch the latest version. Please try again later.');
        });
});