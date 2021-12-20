# AsynAwaitPlayground

Repository contains simple project testing possibilities of async, await with not thread safe collections.

When creating an asynchronous function we need to add an “async” keyword after function definition before throws.

```swift
func test() async throws -> Bool { ... }
```

But when waiting for the result, we put the `try` keyword before the `await` keyword.

```swift
let result = try await test()
```

Only read-only properties can be async, you can’t assign value to async properties.

We can use await inside for loops:

```swift
for await id in array {
      let image = await fetchAyncImage(for: id)
	images.add(image)
}

let result = await images.draw()
```

## Responsibility of managing async code
When calling await we push the responsibility of managing asynchronous code to the System.
It means that we can’t say when and on which thread code will be executed, if it will be the same thread, but we can say that it will eventually return to our code.
It might also be executed synchronously, if it will meet some conditions like free thread and instant return.
It might also push another more important task before it to be executed on this thread.
State of the app might drastically changed while await code is being executed.

## Testing
When using async / await we will just add “async” to our test definition.

```swift
func testFetchingData() async throws { ... }
```

## Using async / await inside async closures like viewDidLoad

```swift
func viewDidLoad() {
  Task {
     self.image = try? await presenter.getImage()
  }
}
```

## Not thread safe collections

When using closures with not thread safe collections like dictionary we need to make sure that they are thread safe.
When using the async / await, we are returning values to TaskGroup and loop them inside for loop, it is already thread safe.
See the implementation inside [CryptoCurrenciesManager](https://github.com/karolpiateknet/AsynAwaitPlayground/blob/main/ThreadsPlayground/Threads/CryptoCurrenciesManager.swift)

## Wrapping NSURLSession in async / await before iOS 15
https://github.com/karolpiateknet/iOS-Best-Practices/pull/1
