// // save as getCookies.js
// const puppeteer = require('puppeteer');

// (async () => {
// const browser = await puppeteer.launch({
//   headless: false,
//   args: ['--ozone-platform=wayland']
// });
//   const page = await browser.newPage();

//   const url = 'https://wallpaperflare.com';
  
//   await page.setViewport({ width: 1920, height: 1080 });



//   await page.goto(url, { waitUntil: 'networkidle2' });

//   const cookies = await page.cookies();
//   cookies.forEach(cookie => {
//     console.log(`${cookie.name}=${cookie.value}`);
//   });

//   await browser.close();
// })();

const puppeteer = require('puppeteer-extra');
const StealthPlugin = require('puppeteer-extra-plugin-stealth');
const readline = require('readline');

// Use the stealth plugin to avoid detection
puppeteer.use(StealthPlugin());

(async () => {
  const browser = await puppeteer.launch({
    headless: false,
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',
      '--disable-accelerated-2d-canvas',
      '--no-first-run',
      '--no-zygote',
      // '--disable-gpu',
      '--ozone-platform=wayland'
    ]
  });

  const page = await browser.newPage();

  // Set a realistic user agent
  await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36');

  await page.setViewport({ width: 1920, height: 1080 });

  const url = 'https://wallpaperflare.com';

  console.log('Navigating to the website...');
  await page.goto(url, { waitUntil: 'networkidle2' });

  // await page.goto(url, { 
  //   waitUntil: 'networkidle2',
  //   timeout: 60000 // Increase timeout to 60 seconds
  // });

  // Wait specifically for Cloudflare challenge to complete
  try {
    console.log('Waiting for Cloudflare check...');
    await page.waitForFunction(() => {
      const challenge = document.querySelector('#challenge-form');
      if (challenge && challenge.style.display === 'none') {
        return true;
      }
      return !document.querySelector('#challenge-form');
    }, {
      timeout: 30000,
      polling: 1000
    });
  } catch (error) {
    console.log('Cloudflare challenge may still be present or timed out');
  }

  // Get cookies after challenge is complete
  const cookies = await page.cookies();
  console.log('\nCookies retrieved:');
  cookies.forEach(cookie => {
    console.log(`${cookie.name}=${cookie.value}`);
  });

  // Wait for manual key press before exiting
  console.log('\nPress any key to exit...');
  await waitForKeyPress();

  await browser.close();
})();

// Helper function to wait for key press
function waitForKeyPress() {
  return new Promise((resolve) => {
    const rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    });

    process.stdin.on('keypress', (str, key) => {
      rl.close();
      resolve();
    });

    // Set raw mode to get individual key presses
    if (process.stdin.isTTY) {
      process.stdin.setRawMode(true);
    }
  });
}