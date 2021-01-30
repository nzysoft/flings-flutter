/// Thrown when an attempt to access a non-existent Todo is made
class DoesNotExistError extends Error {}

/// Thrown when an attempt is made to add a Todo with an ID that already exists
class AlreadyExistsError extends Error {}
