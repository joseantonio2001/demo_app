# Demo App for secure_framework

This is a test application developed for the testing and demonstration of the `secure_framework`'s functionality.

It was created as a proof-of-concept within the Master's Thesis project "Development of a framework using Ruby on Rails to enable the construction of a web application with secure components." Its primary goal is to provide a practical, hands-on example of how `secure_framework` operates and is integrated into a standard Rails application.

---

## 🚀 Key Technologies and Gems

The application is built on **Ruby on Rails 7** and uses several gems to implement its security features:

* **`secure_framework`**: The local framework developed for the thesis, which centralizes security configurations.
* **`devise`**: For handling user authentication (registration, login, password recovery).
* **`pundit`**: For managing authorization policies (access control to resources).
* **`secure_headers`**: For configuring HTTP security headers.
* **`brakeman`**: For static analysis of code vulnerabilities.
* **`rspec-rails`**: For implementing the test suite.

---

## ✨ Demonstrated Features and Security Measures

The `demo_app` includes a series of integration tests (`feature specs`) that validate the following security features provided by the `secure_framework`:

### Authentication and Session Management
* **User Registration**: Secure creation of new accounts.
* **Session Management**: Secure handling of the session lifecycle (login and logout).
* **Account Lockout**: Automatic account locking after multiple failed login attempts.
* **Password Recovery**: A secure process for users to reset their password.

### Authorization
* **Access Control**: Using `Pundit` to restrict access to certain areas (like the Dashboard) to authenticated users only.
* **Action Authorization**: Controlling which actions a user can perform on a resource (e.g., only the creator of a post can edit or delete it).

### Application Security
* **Security Headers**: Implementation of robust HTTP headers (`Content-Security-Policy`, `X-Frame-Options`, etc.) to mitigate attacks like XSS and Clickjacking.
* **Input Sanitization**: Cleaning HTML in user input to prevent Cross-Site Scripting (XSS) attacks when creating or updating posts.
* **Content Security Policy (CSP)**: Configuration of a strict CSP to control the resources the browser is allowed to load.

---

## 🛠️ Installation and Setup

To run the `demo_app` in a local environment, follow these steps:

**Prerequisites:**
* Ruby (version 3.0.0 or higher).
* Bundler.
* Node.js.
* Yarn.
* SQLite3.

**Steps:**

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/joseantonio2001/demo_app.git
    cd demo_app
    ```

2.  **Install dependencies:**
    Ensure the `secure_framework` gem is located in the parent directory or adjust the path in the `Gemfile`.
    ```bash
    # Install Ruby gems
    bundle install

    # Install JavaScript packages
    yarn install
    ```

3.  **Run the framework installer:**
    This command will copy the necessary configuration files (like `devise.rb`, `secure_headers.rb`, etc.) from `secure_framework` into your application.
    ```bash
    rails generate secure_framework:install
    ```

4.  **Set up the database:**
    ```bash
    rails db:create
    rails db:migrate
    ```

5.  **Run the application:**
    ```bash
    rails server
    ```
    The application will be available at `http://localhost:3000`.

---

## ✅ Running Tests

To verify that all security and application features are working correctly, you can run the automated test suite:

```bash
bundle exec rspec