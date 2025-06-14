import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api.dart';

class DiseaseServices {
  static Future<Map<String, dynamic>> getDiseaseDetails(String diseaseName) async {
    try {
      print("DEBUG: Fetching disease info for: $diseaseName");
      
      final response = await http.get(
        Uri.parse('${Config.baseURL}/api/disease/${Uri.encodeComponent(diseaseName)}'),
        headers: {'Content-Type': 'application/json'},
      );

      print("DEBUG: Disease API response status: ${response.statusCode}");
      print("DEBUG: Disease API response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['disease'] != null) {
          // Ensure the disease object has all required fields with proper fallbacks
          final diseaseData = data['disease'];
          
          return {
            "success": true,
            "disease": {
              "overview": diseaseData['overview'] ?? "Disease information available - consult healthcare provider.",
              "causes": diseaseData['causes'] ?? "Causes information available - consult healthcare provider.",
              "symptoms": diseaseData['symptoms'] ?? "Symptoms may vary - consult healthcare provider.",
              "treatments": diseaseData['treatments'] ?? "Treatment options available - consult healthcare provider.",
              "prevention": diseaseData['prevention'] ?? "Prevention strategies available - consult healthcare provider.",
              "when_to_see_doctor": diseaseData['when_to_see_doctor'] ?? "Consult healthcare provider if symptoms persist.",
              "prevalence": diseaseData['how_common'] ?? diseaseData['prevalence'] ?? "Prevalence varies - consult healthcare provider for specific information",
              "how_common": diseaseData['how_common'] ?? diseaseData['prevalence'] ?? "Prevalence varies - consult healthcare provider for specific information"
            }
          };
        } else {
          return _getFallbackDiseaseInfo(diseaseName);
        }
      } else {
        return _getFallbackDiseaseInfo(diseaseName);
      }
    } catch (e) {
      print("DEBUG: Disease service error: $e");
      return _getFallbackDiseaseInfo(diseaseName);
    }
  }

  static Map<String, dynamic> _getFallbackDiseaseInfo(String diseaseName) {
    return {
      "success": true,
      "disease": {
        "overview": "$diseaseName is a medical condition that requires proper evaluation by healthcare professionals.",
        "causes": "The causes of $diseaseName can vary. Please consult with a healthcare provider for detailed information about potential causes.",
        "symptoms": "Symptoms may include those you are currently experiencing. A healthcare professional can provide more specific information.",
        "treatments": "Various treatment options may be available for $diseaseName. Please consult with a healthcare professional for appropriate treatment recommendations.",
        "prevention": "Prevention strategies may include general health practices and specific measures. Discuss prevention options with your healthcare provider.",
        "when_to_see_doctor": "Consult a healthcare provider if symptoms persist or worsen, or if you have concerns about your condition.",
        "prevalence": "Frequency information varies. Please consult a healthcare professional for more details.",
        "how_common": "Frequency information varies. Please consult a healthcare professional for more details."
      }
    };
  }
}
