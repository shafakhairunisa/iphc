class SymptomQuestions {
  // Symptom-specific questions (2-3 per symptom)
  static const Map<String, List<Map<String, dynamic>>> symptomSpecificQuestions = {
    // General Symptoms
    'Fever': [
      {
        'title': 'How high is your temperature?',
        'items': ['Low grade (37-38°C)', 'Moderate (38-39°C)', 'High (39°C+)', 'Not measured'],
      },
      {
        'title': 'How did the fever start?',
        'items': ['Gradually', 'Suddenly', 'After chills', 'Don\'t remember'],
      },
    ],
    'Fatigue': [
      {
        'title': 'How would you describe your tiredness?',
        'items': ['Mild tiredness', 'Exhausted', 'Weakness', 'Unable to function'],
      },
      {
        'title': 'When is it worse?',
        'items': ['In the morning', 'After activity', 'All day', 'At night'],
      },
    ],
    'Chills': [
      {
        'title': 'How severe are the chills?',
        'items': ['Mild shivering', 'Moderate shaking', 'Severe shaking', 'Uncontrollable'],
      },
    ],
    'Sweating': [
      {
        'title': 'When do you sweat most?',
        'items': ['At night', 'During day', 'With activity', 'All the time'],
      },
      {
        'title': 'How much sweating?',
        'items': ['Mild sweating', 'Moderate sweating', 'Profuse sweating', 'Soaking clothes'],
      },
    ],
    'Weight loss': [
      {
        'title': 'How much weight have you lost?',
        'items': ['1-2 kg', '3-5 kg', '5+ kg', 'Not sure'],
      },
      {
        'title': 'Over what time period?',
        'items': ['Few weeks', '1-2 months', '3+ months', 'Gradual over time'],
      },
    ],
    'Weight gain': [
      {
        'title': 'How much weight have you gained?',
        'items': ['1-2 kg', '3-5 kg', '5+ kg', 'Not sure'],
      },
      {
        'title': 'Over what time period?',
        'items': ['Few weeks', '1-2 months', '3+ months', 'Gradual over time'],
      },
    ],
    'Lethargy': [
      {
        'title': 'How would you describe your energy level?',
        'items': ['Slightly low', 'Moderately low', 'Very low', 'No energy at all'],
      },
    ],
    'Malaise': [
      {
        'title': 'How would you describe this feeling?',
        'items': ['Generally unwell', 'Weak and tired', 'Sick feeling', 'Something is wrong'],
      },
    ],
    'Dehydration': [
      {
        'title': 'What signs of dehydration do you have?',
        'items': ['Dry mouth', 'Less urination', 'Dizziness', 'All of these'],
      },
    ],

    // Head and Neck
    'Headache': [
      {
        'title': 'Where is your headache located?',
        'items': ['Forehead', 'Temples', 'Back of head', 'All over', 'One side'],
      },
      {
        'title': 'How would you describe the pain?',
        'items': ['Throbbing', 'Sharp/stabbing', 'Dull ache', 'Pressure/tight'],
      },
    ],
    'Sore throat': [
      {
        'title': 'How does your throat feel?',
        'items': ['Scratchy', 'Sharp pain', 'Burning', 'Dry'],
      },
      {
        'title': 'When is it worse?',
        'items': ['Swallowing', 'Talking', 'In the morning', 'All the time'],
      },
    ],
    'Difficulty swallowing': [
      {
        'title': 'What\'s difficult to swallow?',
        'items': ['Liquids only', 'Solids only', 'Both liquids and solids', 'Everything'],
      },
      {
        'title': 'Where do you feel the blockage?',
        'items': ['High in throat', 'Lower throat', 'Chest area', 'Not sure'],
      },
    ],
    'Neck pain': [
      {
        'title': 'Where is the neck pain?',
        'items': ['Front of neck', 'Back of neck', 'Sides of neck', 'All around'],
      },
      {
        'title': 'What makes it worse?',
        'items': ['Moving head', 'Touching', 'Swallowing', 'Nothing specific'],
      },
    ],
    'Stiff neck': [
      {
        'title': 'How stiff is your neck?',
        'items': ['Slightly stiff', 'Moderately stiff', 'Very stiff', 'Cannot move'],
      },
      {
        'title': 'When did the stiffness start?',
        'items': ['Gradually', 'Suddenly', 'After sleeping', 'After injury'],
      },
    ],
    'Dizziness': [
      {
        'title': 'How would you describe the dizziness?',
        'items': ['Room spinning', 'Lightheaded', 'Unsteady', 'Fainting feeling'],
      },
      {
        'title': 'When does it happen?',
        'items': ['Standing up', 'Moving head', 'All the time', 'Random times'],
      },
    ],
    'Loss of smell': [
      {
        'title': 'How much smell have you lost?',
        'items': ['Partial loss', 'Complete loss', 'Comes and goes', 'Strange smells'],
      },
      {
        'title': 'When did you notice it?',
        'items': ['Suddenly', 'Gradually', 'With cold/flu', 'After injury'],
      },
    ],

    // Respiratory Symptoms
    'Cough': [
      {
        'title': 'What type of cough do you have?',
        'items': ['Dry cough', 'Wet/with phlegm', 'Barking sound', 'Whooping'],
      },
      {
        'title': 'When is your cough worse?',
        'items': ['At night', 'In morning', 'After lying down', 'All day'],
      },
    ],
    'Shortness of breath': [
      {
        'title': 'When do you feel short of breath?',
        'items': ['At rest', 'With mild activity', 'With exercise only', 'When lying down'],
      },
      {
        'title': 'How quickly did it start?',
        'items': ['Suddenly', 'Over hours', 'Over days', 'Gradually over weeks'],
      },
    ],
    'Nasal congestion': [
      {
        'title': 'Which nostril is affected?',
        'items': ['Left only', 'Right only', 'Both nostrils', 'Alternating'],
      },
      {
        'title': 'Is there discharge?',
        'items': ['Clear mucus', 'Yellow/green mucus', 'Blood-tinged', 'No discharge'],
      },
    ],
    'Chest pain': [
      {
        'title': 'Where is the chest pain?',
        'items': ['Center of chest', 'Left side', 'Right side', 'All over chest'],
      },
      {
        'title': 'How does it feel?',
        'items': ['Sharp/stabbing', 'Pressure/squeezing', 'Burning', 'Dull ache'],
      },
    ],
    'Throat irritation': [
      {
        'title': 'How would you describe the irritation?',
        'items': ['Tickling sensation', 'Burning feeling', 'Raw feeling', 'Scratchy'],
      },
    ],
    'Phlegm': [
      {
        'title': 'What color is the phlegm?',
        'items': ['Clear/white', 'Yellow', 'Green', 'Blood-tinged'],
      },
      {
        'title': 'How much phlegm?',
        'items': ['Small amounts', 'Moderate amounts', 'Large amounts', 'Constantly'],
      },
    ],
    'Runny nose': [
      {
        'title': 'What type of discharge?',
        'items': ['Clear and watery', 'Thick and clear', 'Yellow/green', 'Blood-tinged'],
      },
      {
        'title': 'How constant is it?',
        'items': ['Occasionally', 'Frequently', 'Constantly', 'Comes and goes'],
      },
    ],
    'Sinus pressure': [
      {
        'title': 'Where do you feel the pressure?',
        'items': ['Forehead', 'Cheeks', 'Around eyes', 'All areas'],
      },
      {
        'title': 'When is it worse?',
        'items': ['Bending over', 'In the morning', 'At night', 'All the time'],
      },
    ],

    // Skin Symptoms
    'Itching': [
      {
        'title': 'Where is the itching?',
        'items': ['All over body', 'Arms/legs', 'Torso', 'Specific spots'],
      },
      {
        'title': 'How severe is the itching?',
        'items': ['Mild irritation', 'Moderate discomfort', 'Severe/unbearable', 'Keeps me awake'],
      },
    ],
    'Skin rash': [
      {
        'title': 'What does the rash look like?',
        'items': ['Red spots', 'Raised bumps', 'Blisters', 'Patches'],
      },
      {
        'title': 'Where is the rash?',
        'items': ['Face/neck', 'Arms/hands', 'Legs/feet', 'Torso'],
      },
    ],
    'Yellowish skin': [
      {
        'title': 'Where do you notice the yellow color?',
        'items': ['Eyes only', 'Face', 'All over skin', 'Hands/feet'],
      },
    ],
    'Red spots over body': [
      {
        'title': 'How are the spots distributed?',
        'items': ['Few scattered spots', 'Many spots', 'Clusters', 'All over body'],
      },
      {
        'title': 'What do the spots look like?',
        'items': ['Flat red spots', 'Raised red spots', 'With white centers', 'Blotchy'],
      },
    ],
    'Bruising': [
      {
        'title': 'Where are the bruises?',
        'items': ['Arms/legs', 'Torso', 'Face', 'All over body'],
      },
      {
        'title': 'How did they appear?',
        'items': ['After injury', 'Spontaneously', 'After minor bumps', 'Don\'t remember'],
      },
    ],
    'Skin peeling': [
      {
        'title': 'Where is the skin peeling?',
        'items': ['Hands/feet', 'Face', 'Arms/legs', 'All over'],
      },
      {
        'title': 'How extensive is the peeling?',
        'items': ['Small flakes', 'Large pieces', 'Sheets of skin', 'Just dry skin'],
      },
    ],
    'Blister': [
      {
        'title': 'What type of blisters?',
        'items': ['Small water blisters', 'Large blisters', 'Blood blisters', 'Pus-filled'],
      },
      {
        'title': 'Where are the blisters?',
        'items': ['Hands/feet', 'Face/mouth', 'Body', 'Multiple areas'],
      },
    ],
    'Blackheads': [
      {
        'title': 'Where are the blackheads?',
        'items': ['Face only', 'Back/chest', 'Multiple areas', 'All over'],
      },
    ],

    // Digestive Symptoms
    'Stomach pain': [
      {
        'title': 'Where exactly is the pain?',
        'items': ['Upper abdomen', 'Lower abdomen', 'All over', 'Around navel'],
      },
      {
        'title': 'When does the pain occur?',
        'items': ['Before eating', 'After eating', 'At night', 'All the time'],
      },
    ],
    'Nausea': [
      {
        'title': 'When do you feel most nauseous?',
        'items': ['In the morning', 'After eating', 'All day', 'At night'],
      },
      {
        'title': 'What makes it better?',
        'items': ['Eating', 'Resting', 'Fresh air', 'Nothing helps'],
      },
    ],
    'Vomiting': [
      {
        'title': 'How often are you vomiting?',
        'items': ['Once', 'Few times a day', 'Multiple times daily', 'Constantly'],
      },
      {
        'title': 'What does the vomit contain?',
        'items': ['Food only', 'Clear liquid', 'Yellow/green liquid', 'Blood'],
      },
    ],
    'Diarrhea': [
      {
        'title': 'How many times per day?',
        'items': ['3-4 times', '5-6 times', '7+ times', 'Constantly'],
      },
      {
        'title': 'What is the consistency?',
        'items': ['Loose/soft', 'Watery', 'With blood', 'With mucus'],
      },
    ],
    'Constipation': [
      {
        'title': 'How long since last bowel movement?',
        'items': ['2-3 days', '4-5 days', '6+ days', 'Over a week'],
      },
    ],
    'Abdominal pain': [
      {
        'title': 'What type of pain is it?',
        'items': ['Cramping', 'Sharp/stabbing', 'Burning', 'Dull ache'],
      },
      {
        'title': 'What makes it worse?',
        'items': ['Eating', 'Movement', 'Pressure', 'Nothing specific'],
      },
    ],
    'Acidity': [
      {
        'title': 'When do you feel the acidity?',
        'items': ['After eating', 'On empty stomach', 'At night', 'All the time'],
      },
      {
        'title': 'Where do you feel it?',
        'items': ['Stomach', 'Chest/throat', 'Both areas', 'Varies'],
      },
    ],
    'Indigestion': [
      {
        'title': 'What symptoms do you have?',
        'items': ['Bloating', 'Stomach pain', 'Feeling full', 'All of these'],
      },
      {
        'title': 'When does it occur?',
        'items': ['During eating', 'After eating', 'Between meals', 'Randomly'],
      },
    ],
    'Loss of appetite': [
      {
        'title': 'How much has your appetite decreased?',
        'items': ['Slightly less', 'Much less', 'Very little appetite', 'No appetite'],
      },
      {
        'title': 'How long has this been going on?',
        'items': ['Few days', 'About a week', 'Few weeks', 'Longer'],
      },
    ],

    // Neurological Symptoms
    'Blurred vision': [
      {
        'title': 'When is vision blurred?',
        'items': ['Always', 'Distance vision', 'Reading/close work', 'Intermittently'],
      },
      {
        'title': 'Which eye is affected?',
        'items': ['Left eye', 'Right eye', 'Both eyes', 'Varies'],
      },
    ],
    'Spinning movements': [
      {
        'title': 'How would you describe this feeling?',
        'items': ['Room spinning', 'I am spinning', 'Swaying feeling', 'Tilting sensation'],
      },
      {
        'title': 'When does it happen?',
        'items': ['Moving head', 'Standing up', 'Lying down', 'Randomly'],
      },
    ],
    'Loss of balance': [
      {
        'title': 'When do you lose balance?',
        'items': ['Walking', 'Standing still', 'Turning', 'Getting up'],
      },
      {
        'title': 'How severe is it?',
        'items': ['Slightly unsteady', 'Need support', 'Fall sometimes', 'Cannot walk'],
      },
    ],
    'Unsteadiness': [
      {
        'title': 'When do you feel unsteady?',
        'items': ['Walking', 'Standing', 'Sitting up', 'All movements'],
      },
    ],
    'Slurred speech': [
      {
        'title': 'How is your speech affected?',
        'items': ['Slightly slurred', 'Moderately slurred', 'Very slurred', 'Cannot speak clearly'],
      },
      {
        'title': 'When is it worse?',
        'items': ['When tired', 'All the time', 'When stressed', 'Getting worse'],
      },
    ],
    'Muscle weakness': [
      {
        'title': 'Where is the weakness?',
        'items': ['Arms', 'Legs', 'Face', 'All over body'],
      },
      {
        'title': 'How severe is the weakness?',
        'items': ['Mild weakness', 'Moderate weakness', 'Severe weakness', 'Cannot move'],
      },
    ],

    // Musculoskeletal Symptoms
    'Joint pain': [
      {
        'title': 'Which joints are affected?',
        'items': ['Knees', 'Hands/fingers', 'Shoulders', 'Multiple joints'],
      },
      {
        'title': 'When is the pain worse?',
        'items': ['In the morning', 'After activity', 'At night', 'All the time'],
      },
    ],
    'Muscle pain': [
      {
        'title': 'Where are the affected muscles?',
        'items': ['Legs', 'Arms', 'Back', 'All over body'],
      },
      {
        'title': 'What type of pain?',
        'items': ['Aching', 'Sharp', 'Cramping', 'Burning'],
      },
    ],
    'Back pain': [
      {
        'title': 'Where is your back pain?',
        'items': ['Lower back', 'Upper back', 'Between shoulders', 'All over'],
      },
      {
        'title': 'What makes it worse?',
        'items': ['Moving', 'Sitting', 'Standing', 'Lying down'],
      },
    ],
    'Knee pain': [
      {
        'title': 'Which knee is affected?',
        'items': ['Left knee', 'Right knee', 'Both knees', 'Alternating'],
      },
      {
        'title': 'When does it hurt?',
        'items': ['Walking', 'Climbing stairs', 'At rest', 'All the time'],
      },
    ],
    'Hip joint pain': [
      {
        'title': 'Which hip is affected?',
        'items': ['Left hip', 'Right hip', 'Both hips', 'Varies'],
      },
      {
        'title': 'When is it worse?',
        'items': ['Walking', 'Getting up', 'At night', 'All movements'],
      },
    ],
    'Swelling joints': [
      {
        'title': 'Which joints are swollen?',
        'items': ['Fingers/hands', 'Knees', 'Ankles', 'Multiple joints'],
      },
      {
        'title': 'How much swelling?',
        'items': ['Mild swelling', 'Moderate swelling', 'Severe swelling', 'Cannot move'],
      },
    ],
    'Movement stiffness': [
      {
        'title': 'When is stiffness worst?',
        'items': ['In the morning', 'After rest', 'After activity', 'All the time'],
      },
      {
        'title': 'Which areas are stiff?',
        'items': ['Joints', 'Muscles', 'Back/neck', 'All over'],
      },
    ],
    'Muscle wasting': [
      {
        'title': 'Where do you notice muscle loss?',
        'items': ['Arms', 'Legs', 'Face', 'All over body'],
      },
      {
        'title': 'How quickly did it happen?',
        'items': ['Over weeks', 'Over months', 'Over years', 'Very gradually'],
      },
    ],

    // Urinary Symptoms
    'Burning micturition': [
      {
        'title': 'When do you feel the burning?',
        'items': ['Start of urination', 'During urination', 'After urination', 'All the time'],
      },
      {
        'title': 'How severe is the burning?',
        'items': ['Mild discomfort', 'Moderate pain', 'Severe pain', 'Unbearable'],
      },
    ],
    'Frequent urination': [
      {
        'title': 'How often do you urinate?',
        'items': ['Every hour', 'Every 2 hours', 'More than usual', 'Constantly feeling need'],
      },
      {
        'title': 'How much urine each time?',
        'items': ['Normal amount', 'Small amounts', 'Very little', 'Large amounts'],
      },
    ],
    'Bladder discomfort': [
      {
        'title': 'What type of discomfort?',
        'items': ['Pressure feeling', 'Pain', 'Fullness', 'Cramping'],
      },
      {
        'title': 'When do you feel it?',
        'items': ['Before urinating', 'After urinating', 'All the time', 'Intermittently'],
      },
    ],
    'Foul smell of urine': [
      {
        'title': 'How strong is the smell?',
        'items': ['Slightly different', 'Moderately strong', 'Very strong', 'Overwhelming'],
      },
      {
        'title': 'When did you first notice it?',
        'items': ['Today', 'Few days ago', 'This week', 'Longer'],
      },
    ],
    'Continuous feel of urine': [
      {
        'title': 'How would you describe this feeling?',
        'items': ['Always need to go', 'Never feel empty', 'Pressure feeling', 'Incomplete emptying'],
      },
    ],
    'Dark urine': [
      {
        'title': 'What color is your urine?',
        'items': ['Dark yellow', 'Orange', 'Brown', 'Red/pink'],
      },
      {
        'title': 'When did you notice the change?',
        'items': ['Today', 'Few days ago', 'This week', 'Gradually'],
      },
    ],

    // Eye Symptoms
    'Redness of eyes': [
      {
        'title': 'Which eye is affected?',
        'items': ['Left eye', 'Right eye', 'Both eyes', 'Alternating'],
      },
      {
        'title': 'Is there discharge?',
        'items': ['No discharge', 'Clear discharge', 'Yellow/green discharge', 'Thick discharge'],
      },
    ],
    'Watering from eyes': [
      {
        'title': 'How much watering?',
        'items': ['Occasional tearing', 'Frequent tearing', 'Constant tearing', 'Streaming tears'],
      },
      {
        'title': 'When is it worse?',
        'items': ['In bright light', 'In wind', 'All the time', 'When reading'],
      },
    ],
    'Yellowing of eyes': [
      {
        'title': 'How yellow are the eyes?',
        'items': ['Slightly yellow', 'Moderately yellow', 'Very yellow', 'Deep yellow'],
      },
      {
        'title': 'Which part is yellow?',
        'items': ['White part only', 'Around iris', 'Entire eye', 'Not sure'],
      },
    ],
    'Blurred and distorted vision': [
      {
        'title': 'How is your vision distorted?',
        'items': ['Wavy lines', 'Dark spots', 'Missing areas', 'Double vision'],
      },
      {
        'title': 'When is it worse?',
        'items': ['Reading', 'Distance viewing', 'All the time', 'In bright light'],
      },
    ],
    'Pain behind the eyes': [
      {
        'title': 'What type of pain?',
        'items': ['Dull ache', 'Sharp pain', 'Pressure', 'Throbbing'],
      },
      {
        'title': 'Which eye?',
        'items': ['Left eye', 'Right eye', 'Both eyes', 'Alternating'],
      },
    ],
    'Visual disturbances': [
      {
        'title': 'What visual problems do you have?',
        'items': ['Flashing lights', 'Floating spots', 'Blind spots', 'Halos around lights'],
      },
      {
        'title': 'When do you notice them?',
        'items': ['All the time', 'In bright light', 'In dark', 'Intermittently'],
      },
    ],

    // Mental Health
    'Anxiety': [
      {
        'title': 'When do you feel most anxious?',
        'items': ['All the time', 'Specific situations', 'At night', 'Randomly'],
      },
      {
        'title': 'What physical symptoms do you have?',
        'items': ['Racing heart', 'Sweating', 'Shortness of breath', 'Trembling'],
      },
    ],
    'Depression': [
      {
        'title': 'How long have you felt this way?',
        'items': ['Few days', 'Few weeks', 'Few months', 'Longer than 6 months'],
      },
      {
        'title': 'What affects your mood most?',
        'items': ['Sleep problems', 'Loss of interest', 'Feeling hopeless', 'Low energy'],
      },
    ],
    'Mood swings': [
      {
        'title': 'How often do your moods change?',
        'items': ['Several times a day', 'Daily', 'Few times a week', 'Weekly'],
      },
      {
        'title': 'How extreme are the mood changes?',
        'items': ['Mild changes', 'Moderate changes', 'Extreme changes', 'Unpredictable'],
      },
    ],
    'Restlessness': [
      {
        'title': 'How would you describe the restlessness?',
        'items': ['Can\'t sit still', 'Feel agitated', 'Need to move', 'Inner tension'],
      },
      {
        'title': 'When is it worse?',
        'items': ['During day', 'At night', 'When stressed', 'All the time'],
      },
    ],
    'Irritability': [
      {
        'title': 'How easily do you get irritated?',
        'items': ['Slightly more than usual', 'Moderately irritable', 'Very irritable', 'Constantly angry'],
      },
      {
        'title': 'What triggers your irritability?',
        'items': ['Small things', 'Noise', 'People', 'Everything'],
      },
    ],
    'Lack of concentration': [
      {
        'title': 'How is your focus affected?',
        'items': ['Slightly distracted', 'Difficulty focusing', 'Cannot concentrate', 'Mind goes blank'],
      },
      {
        'title': 'When is it worse?',
        'items': ['At work/school', 'When reading', 'In conversations', 'All activities'],
      },
    ],
  };

  // Universal questions (same for all symptoms)
  static const List<Map<String, dynamic>> universalQuestions = [
    {
      'title': 'How long have you been feeling this way?',
      'items': ['1–3 days', '4–7 days', 'More than a week'],
    },
    {
      'title': 'How bad does it feel right now?',
      'items': ['Mild', 'Moderate', 'Severe'],
    },
  ];

  // Dynamic "other symptoms" based on main symptom
  static const Map<String, List<String>> relatedSymptoms = {
    // General Symptoms
    'Fever': ['Chills', 'Sweating', 'Body aches', 'Headache'],
    'Fatigue': ['Fever', 'Body aches', 'Headache', 'Difficulty concentrating'],
    'Chills': ['Fever', 'Body aches', 'Headache', 'Sweating'],
    'Sweating': ['Fever', 'Chills', 'Anxiety', 'Palpitations'],
    'Weight loss': ['Loss of appetite', 'Fatigue', 'Nausea', 'Fever'],
    'Weight gain': ['Fatigue', 'Shortness of breath', 'Swelling', 'Depression'],
    'Lethargy': ['Fatigue', 'Depression', 'Sleep problems', 'Loss of appetite'],
    'Malaise': ['Fever', 'Fatigue', 'Body aches', 'Headache'],
    'Dehydration': ['Dizziness', 'Dry mouth', 'Fatigue', 'Dark urine'],

    // Head and Neck
    'Headache': ['Nausea/vomiting', 'Sensitivity to light', 'Neck stiffness', 'Fever'],
    'Sore throat': ['Fever', 'Swollen glands', 'Runny nose', 'Cough'],
    'Difficulty swallowing': ['Sore throat', 'Fever', 'Swollen glands', 'Hoarse voice'],
    'Neck pain': ['Headache', 'Stiffness', 'Fever', 'Swollen glands'],
    'Stiff neck': ['Headache', 'Fever', 'Neck pain', 'Light sensitivity'],
    'Dizziness': ['Nausea', 'Headache', 'Blurred vision', 'Weakness'],
    'Loss of smell': ['Nasal congestion', 'Runny nose', 'Sore throat', 'Cough'],

    // Respiratory Symptoms
    'Cough': ['Fever', 'Shortness of breath', 'Chest pain', 'Sore throat'],
    'Shortness of breath': ['Chest pain', 'Cough', 'Fatigue', 'Dizziness'],
    'Nasal congestion': ['Runny nose', 'Sore throat', 'Headache', 'Cough'],
    'Chest pain': ['Shortness of breath', 'Nausea', 'Sweating', 'Dizziness'],
    'Throat irritation': ['Cough', 'Sore throat', 'Hoarse voice', 'Runny nose'],
    'Phlegm': ['Cough', 'Chest congestion', 'Fever', 'Shortness of breath'],
    'Runny nose': ['Nasal congestion', 'Sneezing', 'Sore throat', 'Cough'],
    'Sinus pressure': ['Headache', 'Nasal congestion', 'Face pain', 'Runny nose'],

    // Skin Symptoms
    'Itching': ['Skin rash', 'Dry skin', 'Redness', 'Swelling'],
    'Skin rash': ['Itching', 'Fever', 'Swelling', 'Pain'],
    'Yellowish skin': ['Yellow eyes', 'Dark urine', 'Fatigue', 'Nausea'],
    'Red spots over body': ['Fever', 'Itching', 'Swollen glands', 'Fatigue'],
    'Bruising': ['Bleeding gums', 'Fatigue', 'Pale skin', 'Weakness'],
    'Skin peeling': ['Itching', 'Redness', 'Dry skin', 'Pain'],
    'Blister': ['Pain', 'Redness', 'Swelling', 'Fever'],
    'Blackheads': ['Acne', 'Oily skin', 'Skin irritation', 'Inflammation'],

    // Digestive Symptoms
    'Stomach pain': ['Nausea/vomiting', 'Diarrhea', 'Fever', 'Loss of appetite'],
    'Nausea': ['Vomiting', 'Stomach pain', 'Headache', 'Fever'],
    'Vomiting': ['Nausea', 'Stomach pain', 'Dehydration', 'Fever'],
    'Diarrhea': ['Stomach pain', 'Nausea', 'Fever', 'Dehydration'],
    'Constipation': ['Stomach pain', 'Bloating', 'Nausea', 'Loss of appetite'],
    'Abdominal pain': ['Nausea', 'Vomiting', 'Fever', 'Bloating'],
    'Acidity': ['Heartburn', 'Chest pain', 'Nausea', 'Bitter taste'],
    'Indigestion': ['Bloating', 'Nausea', 'Stomach pain', 'Loss of appetite'],
    'Loss of appetite': ['Weight loss', 'Nausea', 'Fatigue', 'Depression'],

    // Neurological Symptoms
    'Blurred vision': ['Eye pain', 'Headache', 'Dizziness', 'Light sensitivity'],
    'Spinning movements': ['Dizziness', 'Nausea', 'Loss of balance', 'Headache'],
    'Loss of balance': ['Dizziness', 'Weakness', 'Coordination problems', 'Falls'],
    'Unsteadiness': ['Dizziness', 'Weakness', 'Balance problems', 'Confusion'],
    'Slurred speech': ['Weakness', 'Coordination problems', 'Confusion', 'Dizziness'],
    'Muscle weakness': ['Fatigue', 'Coordination problems', 'Balance issues', 'Numbness'],

    // Musculoskeletal Symptoms
    'Joint pain': ['Stiffness', 'Swelling', 'Fever', 'Muscle pain'],
    'Muscle pain': ['Joint pain', 'Stiffness', 'Fever', 'Fatigue'],
    'Back pain': ['Muscle stiffness', 'Numbness/tingling', 'Weakness', 'Fever'],
    'Knee pain': ['Swelling', 'Stiffness', 'Difficulty walking', 'Limping'],
    'Hip joint pain': ['Back pain', 'Difficulty walking', 'Stiffness', 'Limping'],
    'Swelling joints': ['Joint pain', 'Stiffness', 'Fever', 'Redness'],
    'Movement stiffness': ['Joint pain', 'Muscle pain', 'Morning stiffness', 'Limited range'],
    'Muscle wasting': ['Weakness', 'Fatigue', 'Weight loss', 'Decreased mobility'],

    // Urinary Symptoms
    'Burning micturition': ['Frequent urination', 'Urgency', 'Fever', 'Lower back pain'],
    'Frequent urination': ['Burning sensation', 'Urgency', 'Fever', 'Fatigue'],
    'Bladder discomfort': ['Frequent urination', 'Urgency', 'Burning', 'Lower pain'],
    'Foul smell of urine': ['Burning urination', 'Frequent urination', 'Fever', 'Cloudy urine'],
    'Continuous feel of urine': ['Frequent urination', 'Urgency', 'Incomplete emptying', 'Pressure'],
    'Dark urine': ['Fatigue', 'Yellow skin', 'Nausea', 'Loss of appetite'],

    // Eye Symptoms
    'Redness of eyes': ['Eye discharge', 'Itchy eyes', 'Blurred vision', 'Light sensitivity'],
    'Watering from eyes': ['Eye irritation', 'Light sensitivity', 'Runny nose', 'Sneezing'],
    'Yellowing of eyes': ['Yellow skin', 'Dark urine', 'Fatigue', 'Nausea'],
    'Blurred and distorted vision': ['Eye pain', 'Headache', 'Light sensitivity', 'Dizziness'],
    'Pain behind the eyes': ['Headache', 'Blurred vision', 'Light sensitivity', 'Nausea'],
    'Visual disturbances': ['Headache', 'Eye pain', 'Light sensitivity', 'Dizziness'],

    // Mental Health
    'Anxiety': ['Racing heart', 'Sweating', 'Shortness of breath', 'Trembling'],
    'Depression': ['Fatigue', 'Sleep problems', 'Loss of appetite', 'Difficulty concentrating'],
    'Mood swings': ['Irritability', 'Anxiety', 'Sleep problems', 'Concentration issues'],
    'Restlessness': ['Anxiety', 'Sleep problems', 'Irritability', 'Difficulty concentrating'],
    'Irritability': ['Mood swings', 'Anxiety', 'Sleep problems', 'Headache'],
    'Lack of concentration': ['Fatigue', 'Sleep problems', 'Memory problems', 'Anxiety'],
  };

  // Fallback other symptoms for unknown symptoms
  static const List<String> defaultOtherSymptoms = [
    'Fever', 'Nausea or vomiting', 'Fatigue', 'Diarrhea'
  ];

  // Get questions for a specific symptom
  static List<Map<String, dynamic>> getQuestionsForSymptom(String mainSymptom) {
    List<Map<String, dynamic>> questions = [];

    // Add symptom-specific questions if available
    if (symptomSpecificQuestions.containsKey(mainSymptom)) {
      questions.addAll(symptomSpecificQuestions[mainSymptom]!);
    }

    // Add universal questions
    questions.addAll(universalQuestions);

    // Add dynamic "other symptoms" question
    questions.add({
      'title': 'Do you experience any of these alongside your ${mainSymptom.toLowerCase()}?',
      'items': relatedSymptoms[mainSymptom] ?? defaultOtherSymptoms,
    });

    return questions;
  }
}
