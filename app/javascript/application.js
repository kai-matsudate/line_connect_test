// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import liff from '@line/liff';

document.addEventListener("DOMContentLoaded", async function() {
  await liff.init({
    liffId: ENV['liffId']
  });

  const accessToken = liff.getAccessToken();
  await fetch(
    '/link_accounts',
    {
      method: 'POST',
      body: {
        access_token: accessToken,
      },
    }
  )
});
