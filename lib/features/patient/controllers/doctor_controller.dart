import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../models/doctor_model.dart';
import '../models/review_model.dart';

class DoctorState {
  final List<DoctorModel> allDoctors;
  final bool isLoading;
  final String? error;

  DoctorState({
    required this.allDoctors,
    this.isLoading = false,
    this.error,
  });

  DoctorState copyWith({
    List<DoctorModel>? allDoctors,
    bool? isLoading,
    String? error,
  }) {
    return DoctorState(
      allDoctors: allDoctors ?? this.allDoctors,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  List<DoctorModel> get topRatedDoctors => allDoctors.where((doc) => double.parse(doc.rating) >= 4.7).toList();
}

class DoctorNotifier extends StateNotifier<DoctorState> {
  DoctorNotifier()
      : super(
          DoctorState(
            allDoctors: [],
          ),
        ) {
    fetchAllDoctors();
  }

  // Fetch all doctors from backend
  Future<void> fetchAllDoctors() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await ApiService.get(
        endpoint: '/doctors',
        auth: false,
      );
      
      final data = response['data'] ?? response;
      if (data is List) {
        final doctors = data.map((doc) => DoctorModel.fromJson(doc)).toList();
        state = state.copyWith(
          allDoctors: doctors,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      // Fallback to dummy data if API fails
      _loadDummyData();
    }
  }

  // Fetch single doctor by ID
  Future<DoctorModel?> fetchDoctorById(String doctorId) async {
    try {
      final response = await ApiService.get(
        endpoint: '/doctors/$doctorId',
        auth: false,
      );
      
      final data = response['data'] ?? response;
      return DoctorModel.fromJson(data);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }


  // Dummy data fallback
  void _loadDummyData() {
    state = state.copyWith(
      allDoctors: [
        DoctorModel(
          image: "https://img.freepik.com/free-photo/woman-doctor-wearing-lab-coat-with-stethoscope-isolated_1303-29791.jpg",
          name: "Dr. Sarah Johnson",
          specialization: "Cardiologist",
          rating: "4.8",
          pmdcLicenceNumber: "12345-P",
          reviews: "124",
          experience: "10 Years",
          branch: "City Hospital, North Wing",
          availability: "Available Today",
          bio: "Dr. Sarah Johnson is a highly experienced Cardiologist with over 10 years of practice. She specializes in non-invasive cardiology and heart failure management.",
          qualification: "MBBS, FCPS (Cardiology)",
          doctorFee: 2500.0,
          reviewsList: [
            ReviewModel(doctorId: "1", userName: "John Doe", reviewText: "Excellent doctor, very attentive.", rating: "5"),
            ReviewModel(doctorId: "1", userName: "Jane Smith", reviewText: "Great experience, highly recommend.", rating: "4"),
          ],
          availableDays: ["Mon", "Tue", "Wed", "Fri"],
          availableSlots: ["09:00-09:30 AM", "10:00-10:30 AM", "11:00-11:30 AM", "02:00-02:30 PM", "03:00-03:30 PM", "04:00-04:30 PM"],
        ),
        DoctorModel(
          image: "https://img.freepik.com/free-photo/successful-medical-team_329181-9252.jpg",
          name: "Dr. Michael Chen",
          specialization: "Dermatologist",
          rating: "4.6",
          pmdcLicenceNumber: "67890-P",
          reviews: "89",
          experience: "8 Years",
          branch: "Skin Care Center, Downtown",
          availability: "Available Tomorrow",
          bio: "Dr. Michael Chen is a board-certified Dermatologist specializing in clinical and cosmetic dermatology. He is known for his patient-centric approach.",
          qualification: "MBBS, MD (Dermatology)",
          doctorFee: 2000.0,
          reviewsList: [
            ReviewModel(doctorId: "2", userName: "Alice Brown", reviewText: "Very professional and helpful.", rating: "5"),
          ],
          availableDays: ["Tue", "Thu", "Sat"],
          availableSlots: ["11:00-11:30 AM", "12:00-12:30 PM", "01:00-01:30 PM", "05:00-05:30 PM"],
        ),
        DoctorModel(
          image: "https://img.freepik.com/free-photo/smiling-female-doctor-holding-clipboard-looking-camera_107420-65158.jpg",
          name: "Dr. Emily White",
          specialization: "Pediatrician",
          rating: "4.9",
          pmdcLicenceNumber: "11223-P",
          reviews: "210",
          experience: "12 Years",
          branch: "Children's Health Clinic",
          availability: "Available Today",
          bio: "Dr. Emily White is a compassionate Pediatrician dedicated to providing the best care for infants, children, and adolescents.",
          qualification: "MBBS, DCH, FCPS (Pediatrics)",
          doctorFee: 1800.0,
          reviewsList: [],
          availableDays: ["Mon", "Wed", "Fri"],
          availableSlots: ["08:00-08:30 AM", "09:00-09:30 AM", "10:00-10:30 AM", "11:00-11:30 AM"],
        ),
        DoctorModel(
          image: "https://img.freepik.com/free-photo/handsome-young-male-doctor-with-stethoscope-standing-against-blue-background_662251-343.jpg",
          name: "Dr. Robert Brown",
          specialization: "Neurologist",
          rating: "4.7",
          pmdcLicenceNumber: "44556-P",
          reviews: "156",
          experience: "15 Years",
          branch: "Brain & Spine Institute",
          availability: "Next Week",
          bio: "Dr. Robert Brown is a senior Neurologist with expertise in treating complex neurological disorders including stroke and epilepsy.",
          qualification: "MBBS, MD, DM (Neurology)",
          doctorFee: 3000.0,
          reviewsList: [],
          availableDays: ["Mon", "Thu"],
          availableSlots: ["02:00-02:30 PM", "03:00-03:30 PM", "04:00-04:30 PM"],
        ),
      ],
    );
  }
}
