function launchGame() {
    const frame = document.getElementById('game-frame');
    frame.innerHTML = `
        <iframe src="index.html" width="100%" height="600" style="border:none; border-radius:12px;" allowfullscreen></iframe>
        <p style="margin-top:1rem; font-size:0.9rem; color:#94a3b8;">
            If the game doesn't load, download the full export from GitHub and open index.html locally.
        </p>
    `;
}