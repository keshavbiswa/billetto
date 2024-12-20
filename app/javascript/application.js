// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


window.startClerk = async () => {
  const Clerk = window.Clerk;

  try {
    await Clerk.load();

    function mountUserButton() {
      if (Clerk.user && !document.getElementById('user-button').hasChildNodes()) {
        const userButtonEl = document.getElementById('user-button');
        Clerk.mountUserButton(userButtonEl);
      }
    }

    document.addEventListener("turbolinks:load", mountUserButton);

    mountUserButton();
  } catch (err) {
    console.error('Clerk: ', err);
  }
}