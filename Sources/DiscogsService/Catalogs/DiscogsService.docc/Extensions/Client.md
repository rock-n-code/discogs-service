# ``Client``

## Topics

### Initializers

- ``Client/init(serverURL:configuration:transport:middlewares:)``

### Service endpoints

- ``Client/getService(_:)``

### Authentication endpoints

- ``Client/getRequestToken(_:)``
- ``Client/postAccessToken(_:)``
- ``Client/getUserIdentity(_:)``

### Database endpoints

- ``Client/searchDatabase(_:)``
- ``Client/getArtist(_:)``
- ``Client/getArtistReleases(_:)``
- ``Client/getLabel(_:)``
- ``Client/getLabelReleases(_:)``
- ``Client/getMaster(_:)``
- ``Client/getMasterVersions(_:)``
- ``Client/getRelease(_:)``
- ``Client/getReleaseRating(_:)``
- ``Client/getReleaseRatingByUser(_:)``
- ``Client/putReleaseRatingByUser(_:)``
- ``Client/deleteReleaseRatingByUser(_:)``
- ``Client/getReleaseStats(_:)``

### User Identity

- ``Client/getUserProfile(_:)``
- ``Client/postUserProfile(_:)``
- ``Client/getUserContributions(_:)``
- ``Client/getUserSubmissions(_:)``

### User Collection

- ``Client/getCollectionFolders(_:)``
- ``Client/postCollectionFolders(_:)``
- ``Client/getCollectionFolder(_:)``
- ``Client/postCollectionFolder(_:)``
- ``Client/deleteCollectionFolder(_:)``
- ``Client/getCollectionItemsByRelease(_:)``
- ``Client/getCollectionItemsByFolder(_:)``
- ``Client/postReleaseToCollectionFolder(_:)``
- ``Client/postChangeRatingOfRelease(_:)``
- ``Client/deleteInstanceFromCollectionFolder(_:)``
- ``Client/getCustomFields(_:)``
- ``Client/editFieldsInstance(_:)``
- ``Client/getCollectionValue(_:)``

### User Wantlist

- ``Client/getWantlist(_:)``
- ``Client/addToWantlist(_:)``
- ``Client/updateInWantlist(_:)``
- ``Client/deleteFromWantlist(_:)``
