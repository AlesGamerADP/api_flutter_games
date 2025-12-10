import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/game.dart';
import '../services/game_service.dart';

class GameFormScreen extends StatefulWidget {
  final Game? game;
  final VoidCallback? onSaved;

  const GameFormScreen({
    super.key,
    this.game,
    this.onSaved,
  });

  @override
  State<GameFormScreen> createState() => _GameFormScreenState();
}

class _GameFormScreenState extends State<GameFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final GameService _gameService = GameService();
  bool _isLoading = false;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _plataformaController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _anioController = TextEditingController();
  final TextEditingController _imagenUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.game != null) {
      _nombreController.text = widget.game!.nombre;
      _generoController.text = widget.game!.genero;
      _plataformaController.text = widget.game!.plataforma;
      _descripcionController.text = widget.game!.descripcion;
      _anioController.text = widget.game!.anioLanzamiento.toString();
      _imagenUrlController.text = widget.game!.imagenUrl ?? '';
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _generoController.dispose();
    _plataformaController.dispose();
    _descripcionController.dispose();
    _anioController.dispose();
    _imagenUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveGame() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final game = Game(
        id: widget.game?.id,
        nombre: _nombreController.text.trim(),
        genero: _generoController.text.trim(),
        plataforma: _plataformaController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        anioLanzamiento: int.parse(_anioController.text.trim()),
        imagenUrl: _imagenUrlController.text.trim().isEmpty
            ? null
            : _imagenUrlController.text.trim(),
      );

      if (widget.game == null) {
        await _gameService.createGame(game);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Juego creado correctamente'),
              backgroundColor: Color(0xFF6366F1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        await _gameService.updateGame(widget.game!.id!, game);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Juego actualizado correctamente'),
              backgroundColor: Color(0xFF6366F1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }

      if (mounted) {
        widget.onSaved?.call();
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game == null ? 'Nuevo Juego' : 'Editar Juego'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Juego',
                        prefixIcon: Icon(Icons.sports_esports),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El nombre es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _generoController,
                      decoration: const InputDecoration(
                        labelText: 'Género',
                        prefixIcon: Icon(Icons.category),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El género es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _plataformaController,
                      decoration: const InputDecoration(
                        labelText: 'Plataforma',
                        prefixIcon: Icon(Icons.computer),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'La plataforma es requerida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descripcionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'La descripción es requerida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _anioController,
                      decoration: const InputDecoration(
                        labelText: 'Año de Lanzamiento',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El año es requerido';
                        }
                        final anio = int.tryParse(value);
                        if (anio == null) {
                          return 'Ingresa un año válido';
                        }
                        if (anio < 1970 || anio > DateTime.now().year + 1) {
                          return 'Ingresa un año válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _imagenUrlController,
                      decoration: const InputDecoration(
                        labelText: 'URL de Imagen (Opcional)',
                        prefixIcon: Icon(Icons.image),
                        helperText: 'URL de la imagen del juego',
                      ),
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveGame,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              widget.game == null ? 'Crear Juego' : 'Actualizar Juego',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
