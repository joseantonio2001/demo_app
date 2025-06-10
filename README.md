# Demo App for `secure_framework`

This is a test application developed for the testing and demonstration of the `secure_framework`'s functionality.

It was created as a proof-of-concept within the Master's Thesis project "Development of a framework using Ruby on Rails to enable the construction of a web application with secure components." Its primary goal is to provide a practical, hands-on example of how `secure_framework` operates and is integrated into a standard Rails application.

---

## Core Application Functionality

At its core, `demo_app` is a simple blogging platform where users can manage posts. It defines two primary user roles:

* **Standard User**: Can register, log in, and perform full CRUD (Create, Read, Update, Delete) actions on their own posts. They cannot see or modify posts created by other users.
* **Admin User**: Has all the permissions of a Standard User, plus access to a special administrative dashboard with security monitoring tools.

---

## Administrative Features

The application includes a protected dashboard that provides administrators with access to special security tools implemented by the framework:

* **Security Log Viewer**: A web interface to view the contents of `log/security.log`, providing a real-time audit trail of critical events like failed logins and authorization failures.
* **Dependency Audit**: A UI to run a `bundle-audit` scan on demand and view a report of any known vulnerabilities in the project's dependencies.
* **Secrets Integration Status**: A status badge that confirms whether application secrets (like an `api_key`) have been correctly loaded from Rails' encrypted credentials.

---

## 🚀 Key Technologies and Gems

The application is built on **Ruby on Rails 7** and uses several gems to implement its security features:

* **`secure_framework`**: The local framework developed for the thesis, which centralizes security configurations.
* **`devise`**: For handling user authentication (registration, login, password recovery).
* **`pundit`**: For managing authorization policies (access control to resources).
* **`lograge`**: Used by the framework to create structured, single-line logs.
* **`secure_headers`**: For configuring HTTP security headers.
* **`brakeman`**: For static analysis of code vulnerabilities.
* **`rspec-rails`**: For implementing the test suite.

---

## ✨ Implemented Security Components from `secure_framework`

The `demo_app` includes a series of integration tests (`feature specs`) that validate the following security features provided by the `secure_framework`:

- **Authentication and Session Management**: Secure account creation, login/logout, account lockout after multiple failed login attempts, and a secure password recovery process.

- **Authorization**: Using Pundit to restrict access to authenticated-only areas and to control actions on a per-resource basis (e.g., only the post owner can edit).

- **Detailed Security Logging**: A dedicated `security.log` file records failed logins, account lockouts, and authorization failures.

- **Input Sanitization**: Stripping of HTML in user input to prevent Cross-Site Scripting (XSS) when creating or updating posts.

- **Content Security Policy (CSP)**: Configuration of a strict CSP to control which resources the browser is allowed to load, mitigating injection attacks.

- **HTTP Security Headers**: Automatic implementation of robust headers (`X-Frame-Options`, etc.) to defend against attacks like XSS and Clickjacking.

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

5.  **Configure Secrets (Optional):**
    The admin dashboard includes a check for an `api_key`. To make this check pass and see a "SUCCESS" badge, edit the application's credentials:
    ```bash
    bin/rails credentials:edit
    ```
    And add the following content:
    ```YAML
    api_key: "your-secret-api-key-here"
    ```

6.  **Run the application:**
    ```bash
    rails server
    ```
    The application will be available at `http://localhost:3000`.

---

## ✅ Running Tests

To verify that all security and application features are working correctly, you can run the automated test suite:

```bash
bundle exec rspec