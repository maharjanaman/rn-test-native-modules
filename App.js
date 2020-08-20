import React, {useEffect} from 'react';
import {
  SafeAreaView,
  StyleSheet,
  ScrollView,
  View,
  Text,
  StatusBar,
  TouchableOpacity,
} from 'react-native';

import {Header, Colors} from 'react-native/Libraries/NewAppScreen';

import ToastExample from './ToastExample';
import ESewaModule from './ESewaModule';

const App = () => {
  useEffect(() => {
    ESewaModule.init(
      'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R',
      'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',
    );
  }, []);

  const handleShowToast = () =>
    ToastExample.show('Awesome', ToastExample.SHORT);

  const handleESewaPay = async () => {
    try {
      const data = await ESewaModule.pay('200', 'Apple', '100', 'abc.com');
      console.warn(data);
    } catch (e) {
      console.warn(e);
    }
  };

  return (
    <>
      <StatusBar barStyle="dark-content" />

      <SafeAreaView>
        <ScrollView
          contentInsetAdjustmentBehavior="automatic"
          style={styles.scrollView}>
          <Header />

          {global.HermesInternal == null ? null : (
            <View style={styles.engine}>
              <Text style={styles.footer}>Engine: Hermes</Text>
            </View>
          )}

          <View style={styles.body}>
            <View style={styles.sectionContainer}>
              <TouchableOpacity style={styles.button} onPress={handleShowToast}>
                <Text>Show Toast</Text>
              </TouchableOpacity>

              <TouchableOpacity style={styles.button} onPress={handleESewaPay}>
                <Text>eSewa Pay</Text>
              </TouchableOpacity>
            </View>
          </View>
        </ScrollView>
      </SafeAreaView>
    </>
  );
};

const styles = StyleSheet.create({
  scrollView: {
    backgroundColor: Colors.lighter,
  },
  engine: {
    position: 'absolute',
    right: 0,
  },
  body: {
    backgroundColor: Colors.white,
  },
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
    color: Colors.black,
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
    color: Colors.dark,
  },
  highlight: {
    fontWeight: '700',
  },
  footer: {
    color: Colors.dark,
    fontSize: 12,
    fontWeight: '600',
    padding: 4,
    paddingRight: 12,
    textAlign: 'right',
  },
  button: {
    paddingHorizontal: 10,
    paddingVertical: 20,
    borderWidth: 1,
    borderRadius: 5,
    borderColor: Colors.dark,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 10,
  },
});

export default App;
