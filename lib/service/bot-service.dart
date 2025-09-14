import 'package:fuzzy/fuzzy.dart';
import 'package:intl/intl.dart';

class BotService {
  final Map<List<String>, String> _knowledgeBase = {
    ['hi', 'hello', 'hey', 'yo']: 'Hey there! Nice to hear from you after a while. How have you been?',
    ['yes', 'yeah', 'yep', 'ok']: 'Awesome!',
    ['no', 'nope']: 'Oh, okay. Understood.',
    ['thank', 'thanks', 'thank you', 'thnx']: 'You\'re most welcome!',
    ['good', 'great', 'cool', 'nice']: 'Glad to hear it!',
    ['what is your name', 'whats your name']: 'I don\'t have a name. You can just call me Bot.',
    ['whats up', 'what\'s up', 'sup', 'wazup']: 'Not much, just processing data. What\'s up with you?',
    ['how is your day', 'hows your day', 'how are you doing']: 'It\'s a 10/10! Every day is a good day when you\'re a bot.',
    ['i like you', 'you are cool', 'you\'re cool', 'ur cool']: 'Aww, thanks! I like you too, in a totally platonic, user-to-bot sort of way.',
    ['fuck you', 'f u', 'fuck u']: 'That\'s not very nice. I\'m just here to help.',
    ['i hate you']: 'I\'m sorry to hear that. Is there something I can do to improve?',
  };

  String getResponse(String userInput) {
    final lowerCaseInput = userInput.toLowerCase();

    if (lowerCaseInput.contains('what') && (lowerCaseInput.contains('date') || lowerCaseInput.contains('day'))) {
      final String formattedDate = DateFormat('MMMM d, y').format(DateTime.now());
      return "Today's date is $formattedDate.";
    }

    final allKeywords = _knowledgeBase.keys.expand((k) => k).toList();
    final fuzzy = Fuzzy(allKeywords, options: FuzzyOptions(threshold: 0.7));
    final result = fuzzy.search(lowerCaseInput);

    if (result.isNotEmpty) {
      final matchedKeyword = result.first.item;
      for (var entry in _knowledgeBase.entries) {
        if (entry.key.contains(matchedKeyword)) {
          return entry.value;
        }
      }
    }
    
    return "I don't have a response for that yet. Try asking something else!";
  }
}