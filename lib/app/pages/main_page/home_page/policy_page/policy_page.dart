import 'package:flutter/material.dart';
import 'package:webinar/common/components.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class TermsAndConditionsPage extends StatelessWidget {
  static const String pageName = '/terms-and-conditions';

  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: appbar(title: isArabic ? "سياسة الاستخدام" : "Terms and Conditions"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: isArabic ? _buildArabicTerms() : _buildEnglishTerms(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildArabicTerms() {
    return [
      _buildSectionTitle("📌 المقدمة"),
      _buildSectionText("مرحبًا بك في تطبيق [الجمعية المصرية لزراعة الأسنان]، وهو منصة تعليمية تهدف إلى تقديم دورات تدريبية متخصصة في المجال الطبي. باستخدامك لهذا التطبيق، فإنك توافق على جميع الشروط والأحكام الواردة في هذه السياسة. يُرجى قراءتها بعناية قبل استخدام التطبيق."),

      _buildSectionTitle("1. الشروط العامة"),
      _buildBulletPoint("يُتاح التطبيق للأطباء والممارسين الصحيين والطلاب المهتمين بالتعليم الطبي."),
      _buildBulletPoint("يجب أن يكون المستخدم مؤهلاً قانونيًا لاستخدام التطبيق وفقًا للقوانين المحلية."),
      _buildBulletPoint("جميع المحتويات داخل التطبيق، بما في ذلك الفيديوهات والمواد التعليمية، مخصصة لأغراض تعليمية فقط ولا يُمكن اعتبارها استشارة طبية."),

      _buildSectionTitle("2. التسجيل والحساب"),
      _buildBulletPoint("يتطلب التسجيل في التطبيق تقديم معلومات دقيقة وصحيحة مثل الاسم والبريد الإلكتروني والتخصص الطبي (إن وجد)."),
      _buildBulletPoint("يجب على المستخدمين الحفاظ على سرية بيانات تسجيل الدخول وعدم مشاركتها مع أي شخص آخر."),
      _buildBulletPoint("يحق لإدارة التطبيق تعليق أو إلغاء حساب أي مستخدم يخالف الشروط أو يستخدم التطبيق لأغراض غير قانونية."),

      _buildSectionTitle("3. حقوق الملكية الفكرية"),
      _buildBulletPoint("جميع المواد التعليمية والمحتويات المتوفرة داخل التطبيق محمية بحقوق الملكية الفكرية."),
      _buildBulletPoint("لا يُسمح بنسخ أو إعادة توزيع أو بيع أي من المحتويات بدون إذن خطي من إدارة التطبيق."),
      _buildBulletPoint("يُمنع استخدام أي جزء من المحتوى لأغراض تجارية أو خارج نطاق التعلم الشخصي."),

      _buildSectionTitle("4. الدفع والاشتراكات"),
      _buildBulletPoint("بعض الدورات داخل التطبيق قد تكون مدفوعة، ويتم دفع الرسوم عبر وسائل الدفع المتاحة."),
      _buildBulletPoint("جميع المبالغ المدفوعة غير قابلة للاسترداد إلا في حالات خاصة تحددها إدارة التطبيق."),
      _buildBulletPoint("يتم تجديد الاشتراكات تلقائيًا ما لم يقم المستخدم بإلغائها قبل موعد التجديد."),
      _buildBulletPoint("📌 **صلاحية الدورات المشتراة هي سنة واحدة فقط من تاريخ الشراء، وبعد ذلك يتم إلغاء الوصول إليها تلقائيًا.**"),

      _buildSectionTitle("5. الاستخدام المسموح به"),
      _buildBulletPoint("يُمنع نشر أو مشاركة أي محتوى غير لائق أو مسيء داخل التطبيق."),
      _buildBulletPoint("لا يُسمح باستخدام التطبيق لنقل معلومات طبية خاطئة أو غير مؤكدة."),
      _buildBulletPoint("يُمنع استخدام أي وسيلة لاختراق التطبيق أو التلاعب بالمحتوى."),

      _buildSectionTitle("6. الخصوصية وحماية البيانات"),
      _buildBulletPoint("يلتزم التطبيق بحماية بيانات المستخدمين وعدم مشاركتها مع أي طرف ثالث بدون موافقتهم."),
      _buildBulletPoint("يتم جمع بعض البيانات مثل بيانات التسجيل وسجل الكورسات لأغراض تحسين التجربة التعليمية."),
      _buildBulletPoint("يمكن الاطلاع على سياسة الخصوصية الكاملة داخل التطبيق."),

      _buildSectionTitle("7. إخلاء المسؤولية الطبية"),
      _buildBulletPoint("المعلومات والمواد التعليمية داخل التطبيق مقدمة لأغراض تعليمية فقط."),
      _buildBulletPoint("لا يُمكن اعتبار المحتوى الطبي داخل التطبيق كبديل عن الاستشارة الطبية المتخصصة."),
      _buildBulletPoint("لا يتحمل التطبيق أو القائمون عليه أي مسؤولية عن أي قرار طبي يتم اتخاذه بناءً على المعلومات المتوفرة داخله."),

      _buildSectionTitle("8. التعديلات على السياسة"),
      _buildBulletPoint("يحق لإدارة التطبيق تعديل هذه السياسة في أي وقت، وسيتم إخطار المستخدمين بأي تغييرات عبر البريد الإلكتروني أو داخل التطبيق."),
      _buildBulletPoint("استمرار استخدام التطبيق بعد التعديلات يعني موافقتك على التغييرات الجديدة."),

      _buildSectionTitle("9. التواصل والدعم"),
      _buildBulletPoint("في حال وجود أي استفسارات أو شكاوى، يمكنكم التواصل مع فريق الدعم عبر البريد الإلكتروني: Education@esoiegypt.com"),
    ];
  }

  List<Widget> _buildEnglishTerms() {
    return [
      _buildSectionTitle("📌 Introduction"),
      _buildSectionText("Welcome to [Egyptian society of oral implantology], an educational platform designed to provide specialized training courses in the medical field. By using this app, you agree to all terms and conditions outlined in this policy. Please read it carefully before using the app."),

      _buildSectionTitle("1. General Terms"),
      _buildBulletPoint("The app is available for doctors, healthcare practitioners, and students interested in medical education."),
      _buildBulletPoint("Users must be legally eligible to use the app according to local laws."),
      _buildBulletPoint("All content within the app, including videos and educational materials, is for educational purposes only and should not be considered medical consultation."),

      _buildSectionTitle("2. Registration and Account"),
      _buildBulletPoint("Registration in the app requires providing accurate and correct information such as name, email, and medical specialty (if applicable)."),
      _buildBulletPoint("Users must keep their login credentials confidential and not share them with anyone else."),
      _buildBulletPoint("The app management reserves the right to suspend or terminate any user account that violates the terms or is used for unlawful purposes."),

      _buildSectionTitle("3. Intellectual Property Rights"),
      _buildBulletPoint("All educational materials and content available in the app are protected by intellectual property rights."),
      _buildBulletPoint("Copying, redistributing, or selling any content without written permission from the app management is not allowed."),
      _buildBulletPoint("Using any part of the content for commercial purposes or beyond personal learning is prohibited."),

      _buildSectionTitle("4. Payment and Subscriptions"),
      _buildBulletPoint("Some courses within the app may require payment, and fees are processed through the available payment methods."),
      _buildBulletPoint("All paid amounts are non-refundable except in special cases determined by the app management."),
      _buildBulletPoint("Subscriptions are automatically renewed unless the user cancels before the renewal date."),
      _buildBulletPoint("📌 **Purchased courses are valid for one year from the date of purchase, after which access will be automatically revoked.**"),

      _buildSectionTitle("5. Permitted Use"),
      _buildBulletPoint("It is prohibited to publish or share any inappropriate or offensive content within the app."),
      _buildBulletPoint("Users are not allowed to use the app to transmit false or unverified medical information."),
      _buildBulletPoint("Any attempt to hack or manipulate the app's content is strictly prohibited."),

      _buildSectionTitle("6. Privacy and Data Protection"),
      _buildBulletPoint("The app is committed to protecting users' data and will not share it with any third party without consent."),
      _buildBulletPoint("Some data, such as registration details and course history, is collected to enhance the educational experience."),
      _buildBulletPoint("The complete privacy policy can be accessed within the app."),

      _buildSectionTitle("7. Medical Disclaimer"),
      _buildBulletPoint("The information and educational materials provided in the app are for learning purposes only."),
      _buildBulletPoint("Medical content in the app should not be considered a substitute for professional medical consultation."),
      _buildBulletPoint("The app and its operators are not responsible for any medical decisions made based on its content."),

      _buildSectionTitle("8. Policy Amendments"),
      _buildBulletPoint("The app management reserves the right to amend this policy at any time, and users will be notified of any changes via email or in-app notifications."),
      _buildBulletPoint("Continued use of the app after changes means acceptance of the new terms."),

      _buildSectionTitle("9. Contact and Support"),
      _buildBulletPoint("For any inquiries or complaints, you can contact our support team via email: Education@esoiegypt.com"),
    ];
  }


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red[800]),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
