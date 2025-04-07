import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/models/role_model.dart';
import '../data/models/user_model.dart';
import '../data/models/car_type_model.dart';
import '../data/models/brand_model.dart';
import '../data/models/model_model.dart';
import '../data/models/car_model.dart';
import '../data/models/feature_model.dart';
import '../data/models/car_feature_model.dart';
import '../data/models/image_model.dart';
import '../data/models/favorite_model.dart';
import '../data/models/message_model.dart';
import '../data/models/report_model.dart';
import '../data/models/review_model.dart';
import '../data/models/post_model.dart';
import '../data/repositories/role_repository.dart';
import '../data/repositories/user_repository.dart';
import '../data/repositories/car_type_repository.dart';
import '../data/repositories/brand_repository.dart';
import '../data/repositories/model_repository.dart';
import '../data/repositories/car_repository.dart';
import '../data/repositories/feature_repository.dart';
import '../data/repositories/car_feature_repository.dart';
import '../data/repositories/image_repository.dart';
import '../data/repositories/favorite_repository.dart';
import '../data/repositories/message_repository.dart';
import '../data/repositories/report_repository.dart';
import '../data/repositories/review_repository.dart';
import '../data/repositories/post_repository.dart';

class InitDataScreen extends StatelessWidget {
  Future<void> initializeData() async {
    final roleRepo = RoleRepository();
    final userRepo = UserRepository();
    final carTypeRepo = CarTypeRepository();
    final brandRepo = BrandRepository();
    final modelRepo = ModelRepository();
    final carRepo = CarRepository();
    final featureRepo = FeatureRepository();
    final carFeatureRepo = CarFeatureRepository();
    final imageRepo = ImageRepository();
    final favoriteRepo = FavoriteRepository();
    final messageRepo = MessageRepository();
    final reportRepo = ReportRepository();
    final reviewRepo = ReviewRepository();
    final postRepo = PostRepository();

    // Thêm VaiTro
    final roles = [
      Role(id: 1, name: 'user'),
      Role(id: 2, name: 'admin'),
    ];
    for (var role in roles) {
      await roleRepo.addRole(role);
    }

    // Thêm TaiKhoan
    final users = [
      User(
        id: 1,
        name: 'Hoang Phuc',
        email: 'phucphuc2004444@gmail.com',
        phone: '0944404698',
        password: 'Phuc@12345',
        address: '123 Street, HCM',
        roleId: 2,
        status: 'HoatDong',
        creationDate: Timestamp.now(),
        updateDate: Timestamp.now(),
      ),
      User(
        id: 2,
        name: 'Phuc Hoang',
        email: 'phucphucvo2004444@gmail.com',
        phone: '0949875403',
        password: 'Phuc@123456',
        address: '456 Road, HN',
        roleId: 2,
        status: 'HoatDong',
        creationDate: Timestamp.now(),
        updateDate: Timestamp.now(),
      ),
      // Thêm các tài khoản khác
    ];
    for (var user in users) {
      await userRepo.addUser(user);
    }

    // Thêm LoaiXe
    final carTypes = [
      CarType(id: 1, name: 'Sedan'),
      CarType(id: 2, name: 'SUV'),
      CarType(id: 3, name: 'Hatchback'),
      CarType(id: 4, name: 'Pickup'),
      CarType(id: 5, name: 'Coupe'),
      CarType(id: 6, name: 'Convertible'),
      CarType(id: 7, name: 'Wagon'),
      CarType(id: 8, name: 'Minivan'),
      CarType(id: 9, name: 'Crossover'),
      CarType(id: 10, name: 'Roadster'),
    ];
    for (var type in carTypes) {
      await carTypeRepo.addCarType(type);
    }

    // Thêm HangXe
    final brands = [
      Brand(id: 1, name: 'Toyota'),
      Brand(id: 2, name: 'Honda'),
      Brand(id: 3, name: 'Ford'),
      Brand(id: 4, name: 'Chevrolet'),
      Brand(id: 5, name: 'BMW'),
      Brand(id: 6, name: 'Audi'),
      Brand(id: 7, name: 'Mercedes-Benz'),
      Brand(id: 8, name: 'Nissan'),
      Brand(id: 9, name: 'Hyundai'),
      Brand(id: 10, name: 'Kia'),
    ];
    for (var brand in brands) {
      await brandRepo.addBrand(brand);
    }

    // Thêm DongXe
    final models = [
      CarModel(id: 1, brandId: 1, name: 'Camry'),
      CarModel(id: 2, brandId: 1, name: 'Corolla'),
      CarModel(id: 3, brandId: 2, name: 'Civic'),
      CarModel(id: 4, brandId: 2, name: 'Accord'),
      CarModel(id: 5, brandId: 3, name: 'F-150'),
      CarModel(id: 6, brandId: 3, name: 'Mustang'),
      CarModel(id: 7, brandId: 4, name: 'Cruze'),
      CarModel(id: 8, brandId: 4, name: 'Malibu'),
      CarModel(id: 9, brandId: 5, name: 'X5'),
      CarModel(id: 10, brandId: 5, name: '3 Series'),
    ];
    for (var model in models) {
      await modelRepo.addModel(model);
    }

    // Thêm Xe và ChiTietXe (kết hợp trong Car model)
    final cars = [
      Car(
        id: 1,
        userId: 1,
        price: 800000000,
        carTypeId: 1,
        modelId: 1,
        year: 2020,
        mileage: 25000,
        fuelType: 'Xang',
        transmission: 'SoSan',
        location: 'Ha Noi',
        licensePlate: '29A-12345',
        chassisNumber: 'A12345',
        engineNumber: 'B12345',
        inspectionDate: DateTime(2025, 12, 31),
        color: 'Den',
        seats: 5,
        registrationDate: DateTime(2020, 1, 1),
        engineCapacity: 2.5,
        creationDate: Timestamp.now(),
        updateDate: Timestamp.now(),
      ),
      // Thêm các xe khác
    ];
    for (var car in cars) {
      await carRepo.addCar(car);
    }

    // Thêm TinhNang
    final features = [
      Feature(id: 1, name: 'Cảm biến lùi'),
      Feature(id: 2, name: 'Cảnh báo điểm mù'),
      Feature(id: 3, name: 'Camera 360'),
      Feature(id: 4, name: 'Hệ thống lái tự động'),
      Feature(id: 5, name: 'Điều hòa tự động'),
      Feature(id: 6, name: 'Màn hình cảm ứng'),
      Feature(id: 7, name: 'Chìa khóa thông minh'),
      Feature(id: 8, name: 'Hệ thống cảnh báo va chạm'),
      Feature(id: 9, name: 'Đèn pha tự động'),
      Feature(id: 10, name: 'Gương chiếu hậu tự động'),
    ];
    for (var feature in features) {
      await featureRepo.addFeature(feature);
    }

    // Thêm XeTinhNang
    final carFeatures = [
      CarFeature(carId: 1, featureId: 1),
      CarFeature(carId: 1, featureId: 2),
      CarFeature(carId: 2, featureId: 1),
      CarFeature(carId: 2, featureId: 4),
      // Thêm các liên kết khác
    ];
    for (var carFeature in carFeatures) {
      await carFeatureRepo.addCarFeature(carFeature);
    }

    // Thêm HinhAnh (dùng URL giả định vì chưa upload ảnh)
    final images = [
      ImageModel(id: 1, carId: 1, url: 'https://link.to/car1.jpg', creationDate: Timestamp.now()),
      ImageModel(id: 2, carId: 2, url: 'https://link.to/car2.jpg', creationDate: Timestamp.now()),
      // Thêm các ảnh khác
    ];
    for (var image in images) {
      await imageRepo.addImage(image);
    }

    // Thêm YeuThich
    final favorites = [
      Favorite(id: 1, userId: 1, carId: 1, creationDate: Timestamp.now()),
      Favorite(id: 2, userId: 1, carId: 2, creationDate: Timestamp.now()),
      // Thêm các yêu thích khác
    ];
    for (var favorite in favorites) {
      await favoriteRepo.addFavorite(favorite);
    }

    // Thêm TinNhan
    final messages = [
      Message(id: 1, senderId: 1, receiverId: 2, content: 'Cảm ơn bạn đã quan tâm tới chiếc xe của tôi!', sentAt: Timestamp.now()),
      Message(id: 2, senderId: 2, receiverId: 3, content: 'Tôi muốn biết thêm về tình trạng xe.', sentAt: Timestamp.now()),
      // Thêm các tin nhắn khác
    ];
    for (var message in messages) {
      await messageRepo.addMessage(message);
    }

    // Thêm BaoCao
    final reports = [
      Report(
        id: 1,
        reporterId: 1,
        reportedUserId: 2,
        reportedCarId: 1,
        reason: 'Xe đã được sửa chữa nhiều lần.',
        status: 'ChoXuLy',
        creationDate: Timestamp.now(),
      ),
      // Thêm các báo cáo khác
    ];
    for (var report in reports) {
      await reportRepo.addReport(report);
    }

    // Thêm BinhLuan
    final reviews = [
      Review(id: 1, reviewerId: 1, carId: 1, content: 'Xe rất đẹp và chạy rất êm.', creationDate: Timestamp.now()),
      // Thêm các bình luận khác
    ];
    for (var review in reviews) {
      await reviewRepo.addReview(review);
    }

    // Thêm TinDang
    final posts = [
      Post(
        id: 1,
        userId: 1,
        carId: 1,
        title: 'Bán xe Toyota Camry 2020, mới 95%',
        description: 'Xe sử dụng rất tốt, chưa qua sửa chữa lớn, bảo dưỡng định kỳ đầy đủ.',
        status: 'ChoDuyet',
        creationDate: Timestamp.now(),
        updateDate: Timestamp.now(),
      ),
      // Thêm các tin đăng khác
    ];
    for (var post in posts) {
      await postRepo.addPost(post);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await initializeData();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data initialized')));
          },
          child: Text('Initialize Data'),
        ),
      ),
    );
  }
}