import 'package:batmancar/viewmodel/car_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

class TelaDirecaoAutomatica extends StatefulWidget {
  const TelaDirecaoAutomatica({super.key});

  @override
  State<TelaDirecaoAutomatica> createState() => _TelaDirecaoAutomaticaState();
}

class _TelaDirecaoAutomaticaState extends State<TelaDirecaoAutomatica> {
  bool _sending = false;
  GoogleMapController? _mapController;

  // centro fixo e zoom fixo
  static const LatLng _fixedCenter =
  LatLng(-5.885384393012014, -35.36383168236036);
  static const double _fixedZoom = 19.0;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CarViewModel>(context);
    final isAutomatico = vm.command.modoAutomatico;

    final double destX = vm.command.destinoX;
    final double destY = vm.command.destinoY;

    return Scaffold(
      backgroundColor: const Color(0xFF101322),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101322),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Direção Automática',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16).copyWith(top: 24),
              child: Column(
                children: [
                  // MAPA DO GOOGLE
                  Container(
                    height: 260,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1D2D),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF2547F4).withValues(alpha: 0.4),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          GoogleMap(
                            mapType: MapType.satellite,
                            initialCameraPosition: const CameraPosition(
                              target: _fixedCenter,
                              zoom: _fixedZoom,
                            ),
                            onMapCreated: _onMapCreated,

                            zoomControlsEnabled: false,
                            zoomGesturesEnabled: false,
                            scrollGesturesEnabled: false,
                            rotateGesturesEnabled: false,
                            tiltGesturesEnabled: false,

                            // só reconhece tap simples
                            gestureRecognizers: {
                              Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer(), // aceita toques básicos
                              ),
                            },

                            onTap: (LatLng pos) async {
                              final vm = context.read<CarViewModel>();
                              await vm.setDestino(pos.latitude, pos.longitude);
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Destino selecionado: (${pos.latitude.toStringAsFixed(7)}, ${pos.longitude.toStringAsFixed(7)})',
                                  ),
                                  backgroundColor: const Color(0xFF2547F4),
                                ),
                              );
                            },

                            markers: {
                              if (destX != 0 && destY != 0)
                                Marker(
                                  markerId: const MarkerId('destino'),
                                  position: LatLng(destX, destY),
                                  consumeTapEvents: true,
                                  onTap: () {
                                  },
                                ),
                            },
                          ),
                          Positioned(
                            left: 16,
                            top: 16,
                            child: Container(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black
                                    .withValues(alpha: 0.5),
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Toque no mapa para definir o destino',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      _buildInfoBox(
                        title: 'Destino atual',
                        value: (destX == 0 && destY == 0)
                            ? 'Nenhum destino definido'
                            : '${destX.toStringAsFixed(7)}, ${destY.toStringAsFixed(7)}',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildActionButton(context, isAutomatico, vm),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              'Conectado',
              style: TextStyle(
                color: const Color(0xFF9CA1BA),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox({required String title, required String value}) {
    return Expanded(
      child: Container(
        padding:
        const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D2D),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, bool isAutomatico, CarViewModel vm) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _sending
            ? null
            : () {
          if (isAutomatico) {
            _stopDriving(vm);
          } else {
            _startDriving(context, vm);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
          isAutomatico ? Colors.redAccent : const Color(0xFF2547F4),
          shadowColor:
          (isAutomatico ? Colors.red : const Color(0xFF2547F4))
              .withValues(alpha: 0.5),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _sending
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            valueColor:
            AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2.5,
          ),
        )
            : Text(
          isAutomatico
              ? 'Parar Condução'
              : 'Iniciar Condução',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.15,
          ),
        ),
      ),
    );
  }

  Future<void> _stopDriving(CarViewModel vm) async {
    setState(() => _sending = true);
    try {
      await vm.setManualMode();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Modo automático desativado.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao parar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _startDriving(
      BuildContext context, CarViewModel vm) async {
    // aqui só iniciamos se já houver um destino definido
    if (vm.command.destinoX == 0 && vm.command.destinoY == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Selecione um destino no mapa antes de iniciar.'),
        ),
      );
      return;
    }

    // se quiser fazer algo extra ao iniciar, pode colocar aqui.
    // o fato de o modo automático estar true já está sendo
    // controlado dentro de setDestino() no CarViewModel.
  }
}