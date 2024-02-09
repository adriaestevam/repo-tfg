import 'package:login_signup_v2/classes/event.dart';

class EventsRepository {
  List<Event> events = [];

  // Create operation: Add an event to the repository
  void addEvent(Event event) {
    events.add(event);
  }

  // Read operation: Get events for a specific date
  List<Event> getEventsForDate(DateTime date) {
    return events.where((event) => event.date == date).toList();
  }

  // Update operation: Update an existing event
  void updateEvent(Event updatedEvent) {
    // Find the index of the event to update
    int index = events.indexWhere((event) => event.id == updatedEvent.id);
    if (index != -1) {
      // Update the event at the found index
      events[index] = updatedEvent;
    }
  }

  // Delete operation: Remove an event from the repository
  void deleteEvent(String eventId) {
    // Find the index of the event to delete
    int index = events.indexWhere((event) => event.id == eventId);
    if (index != -1) {
      // Remove the event at the found index
      events.removeAt(index);
    }
  }
}
