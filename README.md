# One Rep Max app

The goal of this app is to import historical workout data and calculate the theoretical one-rep max for each exercise.

It will also provide a handy way of checking the evolution of those one-rep max values over time.

## Usage

The app implements file handling for plain text files, so importing data will be as easy as opening a text file (with the right format) with the app.

When using the simulator, draggin' and droppin' the file to it will have that same effect.

For simplicity, and given that it wasn't specified differently in the requirements, importing the contents of a new file will automatically delete all the previously existing data.

![](images/drag_n_drop.gif)

## Architecture

Even though SwiftUI is already based on an MVVM architecture, some of the tutorials and guides from Apple still mix some concepts, making it sometimes hard to distinguish roles and responsibilities for the different pieces of code.

In this case, the chosen architecture is a more explicit MVVM, with clear limits between the different components.

Given the complexity of the current app, this approach might seem a bit of over-engineering, but the goal was to showcase how a real-world app would be structured. This way the whole implementation becomes easy to understand and easy to maintain/modify while remaining scalable.

Each screen has its own set of files, composed by a **model**, a **view model** and a **view**, each of those with different responsibilities.

* **Model:** will hold the business logic. In this case, besides the data importing, the app is pretty static, but this layer would hold calls to services or any other specific business logic.
* **View model:** will represent the link between the model and the view. It will hold a model, and it will handle both the data as it is expected by the view and also respond to any user interactions, propagating them down to the model if needed. 
* **View:** responsible for rendering the data and building the UI. It will hold a view model that will provide the data in the right format and also ways to react to user interactions (if any).

In all cases, those diferent pieces are defined using dependency injection and the power of the POP (Protocol-Oriented Programming), which means that there are protocols for the different models and view models, and instead of coupling any specific type, the different properties are injected in the constructors.

This provides several benefits, such as being able to easily switch implementations if needed or providing a simpler way of testing things thanks to the implementation of fakes for each of those cases.

An overview of the different groups and layers can be observed in the following image:

![](images/components.png)

### Persistence

Given that the app handles historical data imported initially from files, it made sense to persist all that information somehow for later use, and avoid having to re-import every time the app is launched. Since iOS already provides means to do that with Core Data, that was the chosen option.

However, and following the same philosophy as with the global architecture, we want for the code to be as generic and flexible as possible. Maybe at some point in the future we need to change the storage provider, and with this implementation including a cloud-based one would even be an option.

The reasoning behind this implementation is that we want to expose a set of models independent from any underlying persistence system, and those are the ones contained in the **Models** folder, i.e. **Exercise**, **ExerciseLog** and **OneRepMax**.

For that same purpose of isolation, there is the **ExerciseStorage** protocol, which establishes the different operations a concrete implementation should provide, and always exposing those persistence-agnostic models.

In this case, only the Core Data implementation has been added, but this implementation provides - as shown in the image - potential to add different implementations for different providers, keeping the specific characteristics of each of them internal to those implementations.

![](images/exercise_storage.png)

Instead of just implementing singletons, a **StorageManager** has been defined on top of those, with the goal of acting as the single access point to the different storages (in this case just one, the **ExerciseStorage**), so that the chosen implementation can be easily changed application-wide.

## Data importing

TBD

## Testing

TBD

### Unit testing

TBD

### Snapshot testing

TBD