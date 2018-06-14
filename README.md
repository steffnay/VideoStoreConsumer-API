# VideoStoreAPI
This Video Store API implementation is based on the Video Store API project that you have previously completed.

## Functionality
This API comes pre-packaged with most of the functionality that you will require. The following endpoints are impemented, based off of the primary and optional requirements of the project.

### Customers

```
GET /customers
```
List all customers

### Movies

```
GET /movies
```
List all movies in the rental library

```
GET /movies?query=<search term>
```
Search for movies in the external Movie DB

```
GET /movies/:title
```
Show details for a single movie by `title`

### Rentals

```
POST /rentals/:title/check-out
```
Check out one of the movie's inventory to the customer. The rental's check-out date should be set to today.

```
POST /rentals/:title/return
```
Check in one of a customer's rentals

```
GET /rentals/overdue
```
List all customers with overdue movies
