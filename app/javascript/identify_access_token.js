document.addEventListener("DOMContentLoaded", async function() {
  await liff.init({
    liffId: '1660751077-Ddxr23Lv'
  });

  const accessToken = liff.getAccessToken();
  console.log(accessToken);
  await fetch(
    '/link_accounts',
    {
      method: 'POST',
      body: {
        access_token: accessToken,
      },
    }
  );
});